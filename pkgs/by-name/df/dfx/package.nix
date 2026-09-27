{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  cmake,
  nix-update-script,
  runCommand,
  gnutar,
  gzip,
}:

let
  src = fetchFromGitHub {
    owner = "dfinity";
    repo = "sdk";
    tag = "0.27.0";
    hash = "sha256-nBc64mgkZiAji8YbV5a8ltPNHMvoGgU/AmgGdCKDuD4=";
  };

  assetsJsonFile = runCommand "dfx-assets-json" { } ''
    cp ${src}/src/dfx/assets/dfx-asset-sources.json $out
  '';

  assetsJson = builtins.fromJSON (builtins.readFile assetsJsonFile);

  validateAssets =
    json:
    let
      required = [
        "x86_64-linux"
        "x86_64-darwin"
        "common"
      ];
      missing = lib.filter (platform: !(json ? ${platform})) required;
    in
    if missing != [ ] then
      throw "Missing required asset platforms: ${lib.concatStringsSep ", " missing}"
    else
      json;

  validatedAssets = validateAssets assetsJson;

  fetchAsset =
    platform: name: asset:
    if asset ? url && asset ? sha256 then
      fetchurl {
        inherit (asset) url sha256;
        name = "${platform}-${name}-${asset.version or asset.rev or "unknown"}";
      }
    else
      throw "Invalid asset definition for ${platform}.${name}: missing url or sha256";

  darwinAssets = lib.mapAttrs (fetchAsset "x86_64-darwin") validatedAssets.x86_64-darwin;
  linuxAssets = lib.mapAttrs (fetchAsset "x86_64-linux") validatedAssets.x86_64-linux;
  commonAssets = lib.mapAttrs (fetchAsset "common") validatedAssets.common;

  allAssets = darwinAssets // linuxAssets // commonAssets;

  createCanisterArchive = name: files: ''
    mkdir -p ${name}_temp
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (dest: src: ''
        if [ -f "${src}" ]; then
          cp ${src} ${name}_temp/${dest}
        else
          echo "Warning: Missing file ${src} for ${name} canister"
        fi
      '') files
    )}
    tar czf $out/${name}_canister.tgz -C ${name}_temp .
    rm -rf ${name}_temp
  '';

  # prepare all assets
  assetsDir =
    runCommand "dfx-assets"
      {
        nativeBuildInputs = [
          gnutar
          gzip
        ];
        preferLocalBuild = true;
      }
      ''
        mkdir -p $out
        mkdir -p binary_cache_temp

        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: asset: ''
            if [[ "${asset}" == *.tar.gz ]]; then
              tar -xzf ${asset} -C binary_cache_temp/
            else
              cp ${asset} binary_cache_temp/${name}
            fi
          '') allAssets
        )}

        tar czf $out/binary_cache.tgz -C binary_cache_temp .
        rm -rf binary_cache_temp

        ${createCanisterArchive "assetstorage" {
          "assetstorage.wasm.gz" = "${src}/src/distributed/assetstorage.wasm.gz";
          "assetstorage.did" = "${src}/src/distributed/assetstorage.did";
        }}

        ${createCanisterArchive "wallet" {
          "wallet.wasm.gz" = "${src}/src/distributed/wallet.wasm.gz";
          "wallet.did" = "${src}/src/distributed/wallet.did";
        }}

        ${createCanisterArchive "ui" {
          "ui.wasm" = "${src}/src/distributed/ui.wasm";
          "ui.did" = "${src}/src/distributed/ui.did";
        }}

        # BTC canister
        mkdir -p btc_temp
        ${lib.optionalString (commonAssets ? "ic-btc-canister") ''
          if [ -f "${commonAssets."ic-btc-canister"}" ]; then
            cp ${commonAssets."ic-btc-canister"} btc_temp/ic-btc-canister.wasm.gz
          else
            echo "Warning: BTC canister asset file not found"
          fi
        ''}
        tar czf $out/btc_canister.tgz -C btc_temp .
        rm -rf btc_temp

        # verify all expected files were created
        for file in binary_cache.tgz assetstorage_canister.tgz wallet_canister.tgz ui_canister.tgz btc_canister.tgz; do
          if [ ! -f "$out/$file" ]; then
            echo "Error: Expected file $file was not created"
            exit 1
          fi
        done
      '';

in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dfx";
  version = "0.27.0";

  inherit src;

  cargoHash = "sha256-0Gi5/4it9rt/AT6LDb3ThfemN+R6EFhZ4xa2jRXg4GE=";

  nativeBuildInputs = [ cmake ];

  env = {
    CRATE_CC_NO_DEFAULTS = "1";
    DFX_ASSETS = assetsDir;
  };

  buildAndTestSubdir = "src/dfx";

  # Disable tests as they require network access and specific setup
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    # expose assets for debugging
    inherit assetsDir;
  };

  meta = {
    description = "SDK for canister smart contracts on the ICP blockchain";
    longDescription = ''
      The DFINITY Canister SDK (dfx) is the primary tool for creating,
      deploying, and managing canisters for the Internet Computer.
    '';
    homepage = "https://github.com/dfinity/sdk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hugolgst ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "dfx";
  };
})
