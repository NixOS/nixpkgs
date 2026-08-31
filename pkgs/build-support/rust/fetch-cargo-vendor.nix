{
  lib,
  stdenvNoCC,
  runCommand,
  writers,
  python3,
  cargo,
  gitMinimal,
  nix-prefetch-git,
  cacert,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
      # The ast-serialize package, a dependency for mypy, depends on
      # fetchCargoVendor and is part of the bootstrap chain for requests.
      charset-normalizer = prev.charset-normalizer.override { withMypyc = false; };
    };
  };
  python3Packages = python.pkgs;

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

  # Arguments not overwritten by `args`
  priorityArgs = [
    "name"
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

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  extendDrvArgs =
    finalAttrs:
    {
      name ?
        if finalAttrs ? pname && finalAttrs ? version then
          "${finalAttrs.pname}-${finalAttrs.version}"
        else
          "cargo-deps",
      hash ? (throw "fetchCargoVendor requires a `hash` value to be set for ${name}"),
      nativeBuildInputs ? [ ],
      ...
    }@args:

    # TODO: add asserts about pname version and name
    {
      inherit
        hash
        ;

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

      outputHash = if finalAttrs.hash == "" then lib.fakeHash else finalAttrs.hash;
      outputHashMode = "recursive";
    }
    # Trick to avoid repetitive `{ <attrname> = args.<attrname> or ...; }`
    // removeAttrs args priorityArgs;

  transformDrv =
    vendorStaging:
    (runCommand "${lib.replaceString "-vendor-staging" "-vendor" vendorStaging.name}"
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
      ''
      # TODO(@ShamrockLee): Remove after converting to stdenvNoCC.mkDerivation
    ).overrideAttrs
      (
        finalAttrs: previousAttrs: {
          name = lib.replaceString "-vendor-staging" "-vendor" finalAttrs.vendorStaging.name;
        }
      );
}
