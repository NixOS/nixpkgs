{
  cuda-redist-feature-detector,
  fetchurl,
  jq,
  lib,
  nixVersions,
  path,
  pkgs,
  srcOnly,
  writers,
  writeShellApplication,
}:
let
  inherit (lib.attrsets) nameValuePair;
  inherit (lib.modules) evalModules;
  inherit (lib.trivial) importJSON pipe;
  inherit (lib.strings) removeSuffix;

  storePathOf =
    let
      nixpkgsRootInStore = path;
    in
    # NOTE: Since nixpkgsRootInStore is an actual Path, we need to make sure we concatenate the directory separator
    # with the stringified `path` argument before concatenating it with nixpkgsRootInStore.
    path: nixpkgsRootInStore + ("/" + path);

  cudaModulesPath = "./pkgs/development/cuda-modules";
  redistIndexModulePath = cudaModulesPath + "/redist-index";
  sha256IndexPath = redistIndexModulePath + "/data/indices/sha256-and-relative-path.json";
  packageIndexPath = redistIndexModulePath + "/data/indices/package-info.json";

  # This does type-checking for us as well as bringing our data and utils helpers into scope.
  inherit
    ((evalModules {
      specialArgs = {
        inherit pkgs;
      };
      modules = [
        (storePathOf redistIndexModulePath)
        { config.data.indices.sha256AndRelativePath = importJSON (storePathOf sha256IndexPath); }
      ];
    }).config
    )
    data
    utils
    ;

  sha256ToUnpackedStorePath = pipe data.indices.sha256AndRelativePath [
    (utils.mapIndexLeavesToList (
      args:
      let
        inherit (args.leaf) sha256;
        tarballSrc = fetchurl {
          inherit sha256;
          url =
            if args.redistName == "tensorrt" then
              utils.mkTensorRTURL args.leaf.relativePath
            else
              utils.mkRedistURL args.redistName (
                utils.mkRelativePath (args // { inherit (args.leaf) relativePath; })
              );
        };
        # Thankfully, using srcOnly is equivalent to using fetchzip!
        unpackedSrc = srcOnly {
          __structuredAttrs = true;
          strictDeps = true;

          preferLocalBuild = true;
          allowSubstitutes = false;

          name = pipe tarballSrc.name [
            (removeSuffix ".tar.xz")
            (removeSuffix ".tar.gz")
          ];
          src = tarballSrc;
        };
      in
      nameValuePair sha256 unpackedSrc
    ))
    builtins.listToAttrs
    # Remove all null values from the result.
    (lib.attrsets.filterAttrsRecursive (_: value: value != null))
    # Write the results to JSON for further processing with JQ.
    (writers.writeJSON "sha256-to-unpacked-store-path.json")
  ];
in
writeShellApplication {
  name = "mk-index-of-package-info";
  runtimeInputs = [
    cuda-redist-feature-detector
    jq
    nixVersions.latest
  ];
  runtimeEnv.JQ_COMMON_FLAGS = [
    "--raw-output"
    "--sort-keys"
  ];
  derivationArgs = {
    __structuredAttrs = true;
    strictDeps = true;
    version = "0.1.0";
  };
  meta = with lib; {
    description = "Generates an index of package information for use in Nixpkgs' CUDA ecosystem.";
    hydraPlatforms = [ ];
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # TODO(@connorbaker): This is a placeholder license. Unfree redistributable because that's what the (majority) of
    # the CUDA redistributable archives are licensed under, but also to prevent Hydra from building and caching
    # this derivation, which contains *all* of the CUDA redistributable archives.
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ connorbaker ];
  };
  text = ''
    unpackedStorePathToNarHashJSONPath="$(mktemp)"
    unpackedStorePathToFeatureJSONPath="$(mktemp)"

    # Check if the input files exist
    if [[ ! -f "${sha256IndexPath}" ]]; then
      echo "The input file ${sha256IndexPath} does not exist"
      exit 1
    fi

    if [[ ! -f "${sha256ToUnpackedStorePath}" ]]; then
      echo "The input file ${sha256ToUnpackedStorePath} does not exist"
      exit 1
    fi

    echo "Acquiring NAR hashes for store paths in ${sha256ToUnpackedStorePath}"
    jq "''${JQ_COMMON_FLAGS[@]}" '.[]' "${sha256ToUnpackedStorePath}" \
      | nix path-info --quiet --json --stdin \
      | jq "''${JQ_COMMON_FLAGS[@]}" 'with_entries(.value |= .narHash)' \
      > "$unpackedStorePathToNarHashJSONPath"

    echo "Acquiring features for store paths in ${sha256ToUnpackedStorePath}"
    jq "''${JQ_COMMON_FLAGS[@]}" '.[]' "${sha256ToUnpackedStorePath}" \
      | cuda-redist-feature-detector --stdin \
      > "$unpackedStorePathToFeatureJSONPath"

    echo "Joining the results"
    jq "''${JQ_COMMON_FLAGS[@]}" --from-file "${./filter.jq}" "${sha256IndexPath}" \
      --slurpfile hashToUnpackedStorePath "${sha256ToUnpackedStorePath}" \
      --slurpfile unpackedStorePathToFeature "$unpackedStorePathToFeatureJSONPath" \
      --slurpfile unpackedStorePathToNarHash "$unpackedStorePathToNarHashJSONPath" \
      > "${packageIndexPath}"

    echo "Cleaning up temporary files"
    rm "$unpackedStorePathToNarHashJSONPath" "$unpackedStorePathToFeatureJSONPath"
  '';
}
