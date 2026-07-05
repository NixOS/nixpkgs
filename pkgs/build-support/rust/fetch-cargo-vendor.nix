{
  lib,
  stdenvNoCC,
  runCommand,
  writers,
  python3Packages,
  cargo,
  gitMinimal,
  nix-prefetch-git,
  cacert,
}:

let
  replaceWorkspaceValues = writers.writePython3Bin "replace-workspace-values" {
    libraries = with python3Packages; [
      tomli
      tomli-w
    ];
    flakeIgnore = [
      "E501"
      "W503"
    ];
  } (builtins.readFile ./replace-workspace-values.py);

  nix-prefetch-git' = nix-prefetch-git.override {
    git = gitMinimal;
    # break loop of nix-prefetch-git -> git-lfs -> asciidoctor -> ruby (yjit) -> fetchCargoVendor -> nix-prefetch-git
    # Cargo does not currently handle git-lfs: https://github.com/rust-lang/cargo/issues/9692
    git-lfs = null;
  };

  removedArgs = [
    "name"
    "pname"
    "version"
    "nativeBuildInputs"
  ];

  fetchCargoVendorUtil = writers.writePython3Bin "fetch-cargo-vendor-util" {
    libraries =
      with python3Packages;
      [
        requests
        tomli-w
      ]
      ++ requests.optional-dependencies.socks; # to support socks proxy envs like ALL_PROXY in requests
    flakeIgnore = [
      "E501"
    ];
  } (builtins.readFile ./fetch-cargo-vendor-util.py);
in

# TODO: add asserts about pname version and name

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;
  excludeDrvArgNames = removedArgs;
  extendDrvArgs =
    finalAttrs:
    {
      name ? if args ? pname && args ? version then "${args.pname}-${args.version}" else "cargo-deps",
      nativeBuildInputs ? [ ],
      ...
    }@args:
    {
      name = "${name}-vendor-staging";

      impureEnvVars = lib.fetchers.proxyImpureEnvVars;

      nativeBuildInputs = [
        fetchCargoVendorUtil
        cacert
        nix-prefetch-git'
      ]
      ++ nativeBuildInputs;

      buildPhase = ''
        runHook preBuild

        if [ -n "''${cargoRoot-}" ]; then
          cd "$cargoRoot"
        fi

        fetch-cargo-vendor-util create-vendor-staging ./Cargo.lock "$out"

        runHook postBuild
      '';

      strictDeps = true;

      dontConfigure = true;
      dontInstall = true;
      dontFixup = true;

      outputHash = finalAttrs.hash or "";
      outputHashAlgo = if finalAttrs.outputHash == "" then "sha256" else null;
      outputHashMode = "recursive";
    };

  transformDrv =
    vendorStaging:
    runCommand "${lib.removeSuffix "-vendor-staging" vendorStaging.name}-vendor"
      {
        inherit vendorStaging;
        nativeBuildInputs = [
          fetchCargoVendorUtil
          cargo
          replaceWorkspaceValues
        ];
      }
      ''
        fetch-cargo-vendor-util create-vendor "$vendorStaging" "$out"
      '';
}
