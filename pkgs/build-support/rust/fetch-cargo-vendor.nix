{
  lib,
  stdenvNoCC,
  runCommand,
  writeText,
  writers,
  python3,
  cargo,
  gitMinimal,
  nix-prefetch-git,
  cacert,
}:

let
  python3Packages = python3.pkgs // {
    # Break the requests -> charset-normalizer -> mypy -> ast-serialize ->
    # fetchCargoVendor bootstrap cycle without overriding the whole Python scope.
    requests = python3.pkgs.requests.override {
      charset-normalizer = python3.pkgs.charset-normalizer.override { withMypyc = false; };
    };
  };

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
    "hash"
    "registryDlOverrides"
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

{
  name ? if args ? pname && args ? version then "${args.pname}-${args.version}" else "cargo-deps",
  hash ? (throw "fetchCargoVendor requires a `hash` value to be set for ${name}"),
  nativeBuildInputs ? [ ],
  # Attribute set mapping a Cargo.lock source string (e.g.
  # "registry+https://github.com/rust-lang/crates.io-index") to a download URL
  # that overrides the `dl` entry advertised by the registry's config.json.
  # The URL follows the same substitution rules as the registry `dl` field
  # (see https://doc.rust-lang.org/cargo/reference/registry-index.html#index-configuration).
  # A bare URL with no `{...}` placeholders is treated as
  # `<url>/{crate}/{version}/download`.
  # Example:
  #   registryDlOverrides = {
  #     "registry+https://github.com/rust-lang/crates.io-index" = "https://static.crates.io/crates";
  #   };
  registryDlOverrides ? { },
  ...
}@args:

# TODO: add asserts about pname version and name

let
  registryDlOverridesFile =
    if registryDlOverrides == { } then
      null
    else
      writeText "registry-dl-overrides.json" (builtins.toJSON registryDlOverrides);

  vendorStaging = stdenvNoCC.mkDerivation (
    {
      name = "${name}-vendor-staging";

      impureEnvVars = lib.fetchers.proxyImpureEnvVars;

      nativeBuildInputs = [
        fetchCargoVendorUtil
        cacert
        nix-prefetch-git'
      ]
      ++ nativeBuildInputs;

      registryDlOverridesFile = if registryDlOverridesFile != null then registryDlOverridesFile else "";

      buildPhase = ''
        runHook preBuild

        if [ -n "''${cargoRoot-}" ]; then
          cd "$cargoRoot"
        fi

        fetch-cargo-vendor-util create-vendor-staging ./Cargo.lock "$out" ''${registryDlOverridesFile:+"$registryDlOverridesFile"}

        runHook postBuild
      '';

      strictDeps = true;

      dontConfigure = true;
      dontInstall = true;
      dontFixup = true;

      outputHash = hash;
      outputHashAlgo = if hash == "" then "sha256" else null;
      outputHashMode = "recursive";

      __structuredAttrs = true;
    }
    // removeAttrs args removedArgs
  );
in
runCommand "${name}-vendor"
  {
    inherit vendorStaging;
    nativeBuildInputs = [
      fetchCargoVendorUtil
      cargo
      replaceWorkspaceValues
    ];
    strictDeps = true;
    __structuredAttrs = true;
  }
  ''
    fetch-cargo-vendor-util create-vendor "$vendorStaging" "$out"
  ''
