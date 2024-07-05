#!/usr/bin/env nix-shell
#! nix-shell --pure
#! nix-shell -i bash
#! nix-shell -p curl cacert
#! nix-shell -p git
#! nix-shell -p nix
#! nix-shell -p jq

set -o pipefail

# How the refresher works:
#
# For a given list of <targets>:
# 1. fetch latest successful '.build` job
# 2. fetch oldest evaluation that contained that '.build', extract nixpkgs commit
# 3. fetch all the `.build` artifacts from '$out/on-server/' directory
# 4. calculate hashes and craft the commit message with the details on
#    how to upload the result to 'tarballs.nixos.org'

scratch_dir=$(mktemp -d)
trap 'rm -rf -- "${scratch_dir}"' EXIT

usage() {
    cat >&2 <<EOF
Usage:
    $0 [ --commit ] --targets=<target>[,<target>,...]

    The tool must be ran from the root directory of 'nixpkgs' repository.

Synopsis:
    'refresh-tarballs.bash' script fetches latest bootstrapFiles built
    by hydra, registers them in 'nixpkgs' and provides commands to
    upload seed files to 'tarballs.nixos.org'.

    This is usually done in the following cases:

    1. Single target fix: current bootstrap files for a single target
       are problematic for some reason (target-specific bug). In this
       case we can refresh just that target as:

       \$ $0 --commit --targets=i686-unknown-linux-gnu

    2. Routine refresh: all bootstrap files should be refreshed to avoid
       debugging problems that only occur on very old binaries.

       \$ $0 --commit --all-targets

To get help on uploading refreshed binaries to 'tarballs.nixos.org'
please have a look at <maintainers/scripts/bootstrap-files/README.md>.
EOF
    exit 1
}

# log helpers

die() {
    echo "ERROR: $*" >&2
    exit 1
}

info() {
    echo "INFO: $*" >&2
}

[[ ${#@} -eq 0 ]] && usage

# known targets

NATIVE_TARGETS=(
    aarch64-unknown-linux-gnu
    aarch64-unknown-linux-musl
    i686-unknown-linux-gnu
    x86_64-unknown-linux-gnu
    x86_64-unknown-linux-musl
    aarch64-apple-darwin
    x86_64-apple-darwin
)

is_native() {
    local t target=$1
    for t in "${NATIVE_TARGETS[@]}"; do
        [[ $t == $target ]] && return 0
    done
    return 1
}

CROSS_TARGETS=(
    armv5tel-unknown-linux-gnueabi
    armv6l-unknown-linux-gnueabihf
    armv6l-unknown-linux-musleabihf
    armv7l-unknown-linux-gnueabihf
    mips64el-unknown-linux-gnuabi64
    mips64el-unknown-linux-gnuabin32
    mipsel-unknown-linux-gnu
    powerpc64-unknown-linux-gnuabielfv2
    powerpc64le-unknown-linux-gnu
    riscv64-unknown-linux-gnu
)

is_cross() {
    local t target=$1
    for t in "${CROSS_TARGETS[@]}"; do
        [[ $t == $target ]] && return 0
    done
    return 1
}

nar_sri_get() {
    local restore_path store_path
    ((${#@} != 2)) && die "nar_sri_get /path/to/name.nar.xz name"
    restore_path="${scratch_dir}/$2"
    xz -d < "$1" | nix-store --restore "${restore_path}"
    [[ $? -ne 0 ]] && die "Failed to unpack '$1'"

    store_path=$(nix-store --add "${restore_path}")
    [[ $? -ne 0 ]] && die "Failed to add '$restore_path' to store"
    rm -rf -- "${restore_path}"

    nix-hash --to-sri "$(nix-store --query --hash "${store_path}")"
}

# collect passed options

targets=()
commit=no

for arg in "$@"; do
    case "$arg" in
        --all-targets)
            targets+=(
                ${CROSS_TARGETS[@]}
                ${NATIVE_TARGETS[@]}
            )
            ;;
        --targets=*)
            # Convert "--targets=a,b,c" to targets=(a b c) bash array.
            comma_targets=${arg#--targets=}
            targets+=(${comma_targets//,/ })
            ;;
        --commit)
            commit=yes
            ;;
        *)
            usage
            ;;
    esac
done

for target in "${targets[@]}"; do
    # Native and cross jobsets differ a bit. We'll have to pick the
    # one based on target name:
    if is_native $target; then
        jobset=nixpkgs/trunk
        job="stdenvBootstrapTools.${target}.build"
    elif is_cross $target; then
        jobset=nixpkgs/cross-trunk
        job="bootstrapTools.${target}.build"
    else
        die "'$target' is not present in either of 'NATIVE_TARGETS' or 'CROSS_TARGETS'. Please add one."
    fi

    # 'nixpkgs' prefix where we will write new tarball hashes
    case "$target" in
        *linux*) nixpkgs_prefix="pkgs/stdenv/linux" ;;
        *darwin*) nixpkgs_prefix="pkgs/stdenv/darwin" ;;
        *) die "don't know where to put '$target'" ;;
    esac

    # We enforce s3 prefix for all targets here. This slightly differs
    # from manual uploads targets where names were chosen inconsistently.
    s3_prefix="stdenv/$target"

    # resolve 'latest' build to the build 'id', construct the link.
    latest_build_uri="https://hydra.nixos.org/job/$jobset/$job/latest"
    latest_build="$target.latest-build"
    info "Fetching latest successful build from '${latest_build_uri}'"
    curl -s -H "Content-Type: application/json" -L "$latest_build_uri" > "$latest_build"
    [[ $? -ne 0 ]] && die "Failed to fetch latest successful build"
    latest_build_id=$(jq '.id' < "$latest_build")
    [[ $? -ne 0 ]] && die "Did not find 'id' in latest build"
    build_uri="https://hydra.nixos.org/build/${latest_build_id}"

    # We pick oldest jobset evaluation and extract the 'nicpkgs' commit.
    #
    # We use oldest instead of latest to make the result more stable
    # across unrelated 'nixpkgs' updates. Ideally two subsequent runs of
    # this refresher should produce the same output (provided there are
    # no bootstrapTools updates committed between the two runs).
    oldest_eval_id=$(jq '.jobsetevals|min' < "$latest_build")
    [[ $? -ne 0 ]] && die "Did not find 'jobsetevals' in latest build"
    eval_uri="https://hydra.nixos.org/eval/${oldest_eval_id}"
    eval_meta="$target.eval-meta"
    info "Fetching oldest eval details from '${eval_uri}' (can take a minute)"
    curl -s -H "Content-Type: application/json"  -L "${eval_uri}" > "$eval_meta"
    [[ $? -ne 0 ]] && die "Failed to fetch eval metadata"
    nixpkgs_revision=$(jq --raw-output ".jobsetevalinputs.nixpkgs.revision" < "$eval_meta")
    [[ $? -ne 0 ]] && die "Failed to fetch revision"

    # Extract the build paths out of the build metadata
    drvpath=$(jq --raw-output '.drvpath' < "${latest_build}")
    [[ $? -ne 0 ]] && die "Did not find 'drvpath' in latest build"
    outpath=$(jq --raw-output '.buildoutputs.out.path' < "${latest_build}")
    [[ $? -ne 0 ]] && die "Did not find 'buildoutputs' in latest build"
    build_timestamp=$(jq --raw-output '.timestamp' < "${latest_build}")
    [[ $? -ne 0 ]] && die "Did not find 'timestamp' in latest build"
    build_time=$(TZ=UTC LANG=C date --date="@${build_timestamp}" --rfc-email)
    [[ $? -ne 0 ]] && die "Failed to format timestamp"

    info "Fetching bootstrap tools to calculate hashes from '${outpath}'"
    nix-store --realize "$outpath"
    [[ $? -ne 0 ]] && die "Failed to fetch '${outpath}' from hydra"

    fnames=()

    target_file="${nixpkgs_prefix}/bootstrap-files/${target}.nix"
    info "Writing '${target_file}'"
    {
        # header
        cat <<EOF
# Autogenerated by maintainers/scripts/bootstrap-files/refresh-tarballs.bash as:
# $ ./refresh-tarballs.bash --targets=${target}
#
# Metadata:
# - nixpkgs revision: ${nixpkgs_revision}
# - hydra build: ${latest_build_uri}
# - resolved hydra build: ${build_uri}
# - instantiated derivation: ${drvpath}
# - output directory: ${outpath}
# - build time: ${build_time}
{
EOF
      for p in "${outpath}/on-server"/*; do
          fname=$(basename "$p")
          fnames+=("$fname")
          case "$fname" in
              bootstrap-tools.tar.xz) attr=bootstrapTools ;;
              busybox) attr=$fname ;;
              unpack.nar.xz) attr=unpack ;;
              *) die "Don't know how to map '$fname' to attribute name. Please update me."
          esac

          executable_arg=
          executable_nix=
          if [[ -x "$p" ]]; then
              executable_arg="--executable"
              executable_nix="executable = true;"
          fi
          unpack_nix=
          name_nix=
          if [[ $fname = *.nar.xz ]]; then
              unpack_nix="unpack = true;"
              name_nix="name = \"${fname%.nar.xz}\";"
              sri=$(nar_sri_get "$p" "${fname%.nar.xz}")
              [[ $? -ne 0 ]] && die "Failed to get hash of '$p'"
          else
              sha256=$(nix-prefetch-url $executable_arg --name "$fname" "file://$p")
              [[ $? -ne 0 ]] && die "Failed to get the hash for '$p'"
              sri=$(nix-hash --to-sri "sha256:$sha256")
              [[ $? -ne 0 ]] && die "Failed to convert '$sha256' hash to an SRI form"
          fi

          # individual file entries
          cat <<EOF
  $attr = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/${s3_prefix}/${nixpkgs_revision}/$fname";
    hash = "${sri}";$(
    [[ -n ${executable_nix} ]] && printf "\n    %s" "${executable_nix}"
    [[ -n ${name_nix} ]]       && printf "\n    %s" "${name_nix}"
    [[ -n ${unpack_nix} ]]     && printf "\n    %s" "${unpack_nix}"
)
  };
EOF
      done
      # footer
      cat <<EOF
}
EOF
    } > "${target_file}"

        target_file_commit_msg=${target}.commit_message
        cat > "$target_file_commit_msg" <<EOF
${nixpkgs_prefix}: update ${target} bootstrap-files

sha256sum of files to be uploaded:

$(
echo "$ sha256sum ${outpath}/on-server/*"
sha256sum ${outpath}/on-server/*
)

Suggested commands to upload files to 'tarballs.nixos.org':

    $ nix-store --realize ${outpath}
    $ aws s3 cp --recursive --acl public-read ${outpath}/on-server/ s3://nixpkgs-tarballs/${s3_prefix}/${nixpkgs_revision}
    $ aws s3 cp --recursive s3://nixpkgs-tarballs/${s3_prefix}/${nixpkgs_revision} ./
    $ sha256sum ${fnames[*]}
    $ sha256sum ${outpath}/on-server/*
EOF

    cat "$target_file_commit_msg"
    if [[ $commit == yes ]]; then
        git commit "${target_file}" -F "$target_file_commit_msg"
    else
        info "DRY RUN: git commit ${target_file} -F $target_file_commit_msg"
    fi
    rm -- "$target_file_commit_msg"

    # delete temp files
    rm -- "$latest_build" "$eval_meta"
done
