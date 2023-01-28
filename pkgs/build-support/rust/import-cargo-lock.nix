{ fetchgit, fetchurl, lib, runCommand, cargo, jq }:

{
  # Cargo lock file
  lockFile ? null

  # Cargo lock file contents as string
, lockFileContents ? null

  # Allow `builtins.fetchGit` to be used to not require hashes for git dependencies
, allowBuiltinFetchGit ? false

  # Hashes for git dependencies.
, outputHashes ? {}
} @ args:

assert (lockFile == null) != (lockFileContents == null);

let
  # Parse a git source into different components.
  parseGit = src:
    let
      parts = builtins.match ''git\+([^?]+)(\?(rev|tag|branch)=(.*))?#(.*)'' src;
      type = builtins.elemAt parts 2; # rev, tag or branch
      value = builtins.elemAt parts 3;
    in
      if parts == null then null
      else {
        url = builtins.elemAt parts 0;
        sha = builtins.elemAt parts 4;
      } // lib.optionalAttrs (type != null) { inherit type value; };

  # shadows args.lockFileContents
  lockFileContents =
    if lockFile != null
    then builtins.readFile lockFile
    else args.lockFileContents;

  packages = (builtins.fromTOML lockFileContents).package;

  # There is no source attribute for the source package itself. But
  # since we do not want to vendor the source package anyway, we can
  # safely skip it.
  depPackages = builtins.filter (p: p ? "source") packages;

  # Create dependent crates from packages.
  #
  # Force evaluation of the git SHA -> hash mapping, so that an error is
  # thrown if there are stale hashes. We cannot rely on gitShaOutputHash
  # being evaluated otherwise, since there could be no git dependencies.
  depCrates = builtins.deepSeq gitShaOutputHash (builtins.map mkCrate depPackages);

  # Map package name + version to git commit SHA for packages with a git source.
  namesGitShas = builtins.listToAttrs (
    builtins.map nameGitSha (builtins.filter (pkg: lib.hasPrefix "git+" pkg.source) depPackages)
  );

  nameGitSha = pkg: let gitParts = parseGit pkg.source; in {
    name = "${pkg.name}-${pkg.version}";
    value = gitParts.sha;
  };

  # Convert the attrset provided through the `outputHashes` argument to a
  # a mapping from git commit SHA -> output hash.
  #
  # There may be multiple different packages with different names
  # originating from the same git repository (typically a Cargo
  # workspace). By using the git commit SHA as a universal identifier,
  # the user does not have to specify the output hash for every package
  # individually.
  gitShaOutputHash = lib.mapAttrs' (nameVer: hash:
    let
      unusedHash = throw "A hash was specified for ${nameVer}, but there is no corresponding git dependency.";
      rev = namesGitShas.${nameVer} or unusedHash; in {
      name = rev;
      value = hash;
    }) outputHashes;

  # We can't use the existing fetchCrate function, since it uses a
  # recursive hash of the unpacked crate.
  fetchCrate = pkg:
    assert lib.assertMsg (pkg ? checksum) ''
      Package ${pkg.name} does not have a checksum.
      Please note that the Cargo.lock format where checksums used to be listed
      under [metadata] is not supported.
      If that is the case, running `cargo update` with a recent toolchain will
      automatically update the format along with the crate's depenendencies.
    '';
    fetchurl {
      name = "crate-${pkg.name}-${pkg.version}.tar.gz";
      url = "https://crates.io/api/v1/crates/${pkg.name}/${pkg.version}/download";
      sha256 = pkg.checksum;
    };

  # Fetch and unpack a crate.
  mkCrate = pkg:
    let
      gitParts = parseGit pkg.source;
    in
      if pkg.source == "registry+https://github.com/rust-lang/crates.io-index" then
      let
        crateTarball = fetchCrate pkg;
      in runCommand "${pkg.name}-${pkg.version}" {} ''
        mkdir $out
        tar xf "${crateTarball}" -C $out --strip-components=1

        # Cargo is happy with largely empty metadata.
        printf '{"files":{},"package":"${pkg.checksum}"}' > "$out/.cargo-checksum.json"
      ''
      else if gitParts != null then
      let
        missingHash = throw ''
          No hash was found while vendoring the git dependency ${pkg.name}-${pkg.version}. You can add
          a hash through the `outputHashes` argument of `importCargoLock`:

          outputHashes = {
            "${pkg.name}-${pkg.version}" = "<hash>";
          };

          If you use `buildRustPackage`, you can add this attribute to the `cargoLock`
          attribute set.
        '';
        tree =
          if gitShaOutputHash ? ${gitParts.sha} then
            fetchgit {
              inherit (gitParts) url;
              rev = gitParts.sha; # The commit SHA is always available.
              sha256 = gitShaOutputHash.${gitParts.sha};
            }
          else if allowBuiltinFetchGit then
            builtins.fetchGit {
              inherit (gitParts) url;
              rev = gitParts.sha;
              allRefs = true;
            }
          else
            missingHash;
      in runCommand "${pkg.name}-${pkg.version}" {} ''
        tree=${tree}

        # If the target package is in a workspace, or if it's the top-level
        # crate, we should find the crate path using `cargo metadata`.
        # Some packages do not have a Cargo.toml at the top-level,
        # but only in nested directories.
        # Only check the top-level Cargo.toml, if it actually exists
        if [[ -f $tree/Cargo.toml ]]; then
          crateCargoTOML=$(${cargo}/bin/cargo metadata --format-version 1 --no-deps --manifest-path $tree/Cargo.toml | \
          ${jq}/bin/jq -r '.packages[] | select(.name == "${pkg.name}") | .manifest_path')
        fi

        # If the repository is not a workspace the package might be in a subdirectory.
        if [[ -z $crateCargoTOML ]]; then
          for manifest in $(find $tree -name "Cargo.toml"); do
            echo Looking at $manifest
            crateCargoTOML=$(${cargo}/bin/cargo metadata --format-version 1 --no-deps --manifest-path "$manifest" | ${jq}/bin/jq -r '.packages[] | select(.name == "${pkg.name}") | .manifest_path' || :)
            if [[ ! -z $crateCargoTOML ]]; then
              break
            fi
          done

          if [[ -z $crateCargoTOML ]]; then
            >&2 echo "Cannot find path for crate '${pkg.name}-${pkg.version}' in the tree in: $tree"
            exit 1
          fi
        fi

        echo Found crate ${pkg.name} at $crateCargoTOML
        tree=$(dirname $crateCargoTOML)

        cp -prvd "$tree/" $out
        chmod u+w $out

        # Cargo is happy with empty metadata.
        printf '{"files":{},"package":null}' > "$out/.cargo-checksum.json"

        # Set up configuration for the vendor directory.
        cat > $out/.cargo-config <<EOF
        [source."${gitParts.url}"]
        git = "${gitParts.url}"
        ${lib.optionalString (gitParts ? type) "${gitParts.type} = \"${gitParts.value}\""}
        replace-with = "vendored-sources"
        EOF
      ''
      else throw "Cannot handle crate source: ${pkg.source}";

  vendorDir = runCommand "cargo-vendor-dir" (lib.optionalAttrs (lockFile == null) {
    inherit lockFileContents;
    passAsFile = [ "lockFileContents" ];
  }) ''
    mkdir -p $out/.cargo

    ${
      if lockFile != null
      then "ln -s ${lockFile} $out/Cargo.lock"
      else "cp $lockFileContentsPath $out/Cargo.lock"
    }

    cat > $out/.cargo/config <<EOF
    [source.crates-io]
    replace-with = "vendored-sources"

    [source.vendored-sources]
    directory = "cargo-vendor-dir"
    EOF

    declare -A keysSeen

    for crate in ${toString depCrates}; do
      # Link the crate directory, removing the output path hash from the destination.
      ln -s "$crate" $out/$(basename "$crate" | cut -c 34-)

      if [ -e "$crate/.cargo-config" ]; then
        key=$(sed 's/\[source\."\(.*\)"\]/\1/; t; d' < "$crate/.cargo-config")
        if [[ -z ''${keysSeen[$key]} ]]; then
          keysSeen[$key]=1
          cat "$crate/.cargo-config" >> $out/.cargo/config
        fi
      fi
    done
  '';
in
  vendorDir
