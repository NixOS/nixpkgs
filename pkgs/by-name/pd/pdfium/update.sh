#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash coreutils curl gawk git gnused gnutar jq nix

set -euo pipefail

script_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd -P)
repo_root=$(git -C "$script_dir" rev-parse --show-toplevel)
sources_file="$script_dir/sources.json"
chromium_git_url="https://chromium.googlesource.com"

resolve_latest_version() {
  git ls-remote --refs https://pdfium.googlesource.com/pdfium 'refs/heads/chromium/*' \
    | awk -F/ '/refs\/heads\/chromium\/[0-9]+$/ { print $NF }' \
    | sort -n \
    | tail -1
}

prefetch() {
  local kind=$1
  local url=$2
  local -a args=(--extra-experimental-features nix-command store prefetch-file --json)

  case $kind in
    archive) args+=(--unpack) ;;
    file) ;;
    *)
      echo "unsupported prefetch kind: $kind" >&2
      exit 1
      ;;
  esac

  nix "${args[@]}" "$url"
}

prefetch_archive_hash() {
  prefetch archive "$1" | jq -er '.hash'
}

prefetch_subdir_archive_hash() (
  local url=$1
  local archive
  local tmp

  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT

  archive=$(prefetch file "$url" | jq -er '.storePath')
  # Gitiles subdirectory archives do not hash like fetchzip with
  # stripRoot = false when passed directly to `nix store prefetch-file
  # --unpack`, so hash the extracted tree instead.
  tar -xzf "$archive" -C "$tmp"
  nix --extra-experimental-features nix-command hash path "$tmp"
)

extract_deps_rev() {
  local deps_file=$1
  local key=$2
  sed -n "s/^  '${key}': '\\([0-9a-f]\\+\\)',$/\\1/p" "$deps_file"
}

target_version=${1:-$(resolve_latest_version)}
if [[ ! $target_version =~ ^[0-9]+$ ]]; then
  echo "invalid PDFium build number: $target_version" >&2
  exit 1
fi
echo "target build: $target_version"

pdfium_url="https://pdfium.googlesource.com/pdfium/+archive/refs/heads/chromium/${target_version}.tar.gz"
pdfium_prefetch=$(prefetch archive "$pdfium_url")
pdfium_hash=$(jq -er '.hash' <<< "$pdfium_prefetch")
pdfium_src=$(jq -er '.storePath' <<< "$pdfium_prefetch")

deps_file="$pdfium_src/DEPS"
build_rev=$(extract_deps_rev "$deps_file" build_revision)
abseil_rev=$(extract_deps_rev "$deps_file" abseil_revision)
fast_float_rev=$(extract_deps_rev "$deps_file" fast_float_revision)
gtest_rev=$(extract_deps_rev "$deps_file" gtest_revision)
test_fonts_rev=$(extract_deps_rev "$deps_file" test_fonts_revision)
simdutf_rev=$(extract_deps_rev "$deps_file" simdutf_revision)

for dep_var in build_rev abseil_rev fast_float_rev gtest_rev test_fonts_rev simdutf_rev; do
  if [[ -z ${!dep_var} ]]; then
    echo "failed to extract $dep_var from $deps_file" >&2
    exit 1
  fi
done

chromium_version=$(
  curl -sSfL "${chromium_git_url}/chromium/src/+/refs/branch-heads/${target_version}/chrome/VERSION?format=TEXT" \
    | base64 -d
)
major=$(sed -n 's/^MAJOR=//p' <<< "$chromium_version")
minor=$(sed -n 's/^MINOR=//p' <<< "$chromium_version")
build=$(sed -n 's/^BUILD=//p' <<< "$chromium_version")
patch=$(sed -n 's/^PATCH=//p' <<< "$chromium_version")

for version_var in major minor build patch; do
  if [[ -z ${!version_var} ]]; then
    echo "failed to extract $version_var from Chromium chrome/VERSION" >&2
    exit 1
  fi
done

build_hash=$(prefetch_archive_hash "${chromium_git_url}/chromium/src/build.git/+archive/${build_rev}.tar.gz")
chromium_buildtools_hash=$(prefetch_archive_hash "${chromium_git_url}/chromium/src/+archive/refs/branch-heads/${target_version}/buildtools.tar.gz")
abseil_hash=$(prefetch_archive_hash "${chromium_git_url}/chromium/src/third_party/abseil-cpp/+archive/${abseil_rev}.tar.gz")
fast_float_hash=$(prefetch_archive_hash "${chromium_git_url}/external/github.com/fastfloat/fast_float/+archive/${fast_float_rev}.tar.gz")
gtest_hash=$(prefetch_archive_hash "${chromium_git_url}/external/github.com/google/googletest/+archive/${gtest_rev}.tar.gz")
generate_shim_headers_hash=$(prefetch_subdir_archive_hash "${chromium_git_url}/chromium/src/+archive/refs/branch-heads/${target_version}/tools/generate_shim_headers.tar.gz")
test_fonts_hash=$(prefetch_archive_hash "${chromium_git_url}/chromium/src/third_party/test_fonts/+archive/${test_fonts_rev}.tar.gz")
test_fonts_bundle_object=$(
  curl -sSfL "${chromium_git_url}/chromium/src/third_party/test_fonts/+/${test_fonts_rev}/test_fonts.tar.gz.sha1?format=TEXT" \
    | base64 -d \
    | tr -d '\n'
)
if [[ -z $test_fonts_bundle_object ]]; then
  echo "failed to extract testFontsBundleObject from Chromium test_fonts repo" >&2
  exit 1
fi
test_fonts_bundle_hash=$(
  prefetch file "https://storage.googleapis.com/chromium-fonts/${test_fonts_bundle_object}" \
    | jq -er '.hash'
)
simdutf_hash=$(prefetch_archive_hash "${chromium_git_url}/chromium/src/third_party/simdutf/+archive/${simdutf_rev}.tar.gz")

tmp=$(mktemp "$script_dir/.sources.json.XXXXXX")
trap 'rm -f "$tmp"' EXIT

jq -n \
  --argjson major "$major" \
  --argjson minor "$minor" \
  --argjson build "$build" \
  --argjson patch "$patch" \
  --arg pdfium_hash "$pdfium_hash" \
  --arg build_rev "$build_rev" \
  --arg build_hash "$build_hash" \
  --arg chromium_buildtools_hash "$chromium_buildtools_hash" \
  --arg abseil_rev "$abseil_rev" \
  --arg abseil_hash "$abseil_hash" \
  --arg fast_float_rev "$fast_float_rev" \
  --arg fast_float_hash "$fast_float_hash" \
  --arg gtest_rev "$gtest_rev" \
  --arg gtest_hash "$gtest_hash" \
  --arg generate_shim_headers_hash "$generate_shim_headers_hash" \
  --arg test_fonts_rev "$test_fonts_rev" \
  --arg test_fonts_hash "$test_fonts_hash" \
  --arg test_fonts_bundle_object "$test_fonts_bundle_object" \
  --arg test_fonts_bundle_hash "$test_fonts_bundle_hash" \
  --arg simdutf_rev "$simdutf_rev" \
  --arg simdutf_hash "$simdutf_hash" \
  '{
    version: {
      major: $major,
      minor: $minor,
      build: $build,
      patch: $patch
    },
    pdfium: { hash: $pdfium_hash },
    build: {
      rev: $build_rev,
      hash: $build_hash
    },
    chromiumBuildtools: { hash: $chromium_buildtools_hash },
    abseil: {
      rev: $abseil_rev,
      hash: $abseil_hash
    },
    fastFloat: {
      rev: $fast_float_rev,
      hash: $fast_float_hash
    },
    gtest: {
      rev: $gtest_rev,
      hash: $gtest_hash
    },
    generateShimHeaders: { hash: $generate_shim_headers_hash },
    testFonts: {
      rev: $test_fonts_rev,
      hash: $test_fonts_hash,
      bundle: {
        object: $test_fonts_bundle_object,
        hash: $test_fonts_bundle_hash
      }
    },
    simdutf: {
      rev: $simdutf_rev,
      hash: $simdutf_hash
    }
  }' > "$tmp"

mv "$tmp" "$sources_file"
trap - EXIT

nix-instantiate "$repo_root" -A pdfium >/dev/null
echo "updated $sources_file"
