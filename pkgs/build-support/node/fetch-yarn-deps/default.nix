{
  stdenvNoCC,
  lib,
  fetchurl,
  rustPlatform,
  makeWrapper,
  makeSetupHook,
  pkg-config,
  nodejsInstallManuals,
  nodejsInstallExecutables,
  curl,
  gnutar,
  gzip,
  nodejs,
  nodejs-slim,
  jq,
  diffutils,
  yarn,
  cacert,
  prefetch-yarn-deps,
  fixup-yarn-lock,
  config,
  callPackage,
}:

let
  yarnpkg-lockfile-tar = fetchurl {
    url = "https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz";
    hash = "sha512-GpSwvyXOcOOlV70vbnzjj4fW5xW/FdUF6nQEt1ENy7m4ZCczi1+/buVUPAqmGfqznsORNFzUMjctTIp8a9tuCQ==";
  };

  tests = callPackage ./tests { };
in
{
  prefetch-yarn-deps = rustPlatform.buildRustPackage {
    pname = "prefetch-yarn-deps";
    version = (lib.importTOML ./Cargo.toml).package.version;

    src = lib.cleanSourceWith {
      src = ./.;
      filter =
        name: type:
        let
          name' = baseNameOf name;
        in
        name' != "default.nix" && name' != "target";
    };

    cargoLock.lockFile = ./Cargo.lock;

    nativeBuildInputs = [
      makeWrapper
      pkg-config
    ];
    buildInputs = [ curl ];

    postInstall = ''
      wrapProgram "$out/bin/prefetch-yarn-deps" --prefix PATH : ${
        lib.makeBinPath [
          gnutar
          gzip
        ]
      }
    '';

    passthru = {
      inherit tests;
    };

    meta = {
      description = "Prefetch dependencies from yarn (for use with `fetchYarnDeps`)";
      mainProgram = "prefetch-yarn-deps";
      license = lib.licenses.mit;
    };
  };

  fixup-yarn-lock = stdenvNoCC.mkDerivation {
    name = "fixup-yarn-lock";

    dontUnpack = true;
    dontBuild = true;

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ nodejs-slim ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/libexec

      tar --strip-components=1 -xf ${yarnpkg-lockfile-tar} package/index.js
      mv index.js $out/libexec/yarnpkg-lockfile.js
      cp ${./fixup.js} $out/libexec/fixup.js

      patchShebangs $out/libexec
      makeWrapper $out/libexec/fixup.js $out/bin/fixup-yarn-lock

      runHook postInstall
    '';

    passthru = {
      inherit tests;
    };
  };

  fetchYarnDeps =
    {
      name ? "yarn-deps",
      src ? null,
      yarnLock ? "",
      hash ? "",
      sha256 ? "",
      forceEmptyCache ? false,
      nativeBuildInputs ? [ ],
      # A string with a JSON attrset specifying registry mirrors, for example
      #   {"registry.example.org": "my-mirror.local/registry.example.org"}
      npmRegistryOverridesString ? config.npmRegistryOverridesString,
      ...
    }@args:
    let
      hash_ =
        if hash != "" then
          {
            outputHash = hash;
            outputHashAlgo = null;
          }
        else if sha256 != "" then
          {
            outputHash = sha256;
            outputHashAlgo = "sha256";
          }
        else
          {
            outputHash = lib.fakeSha256;
            outputHashAlgo = "sha256";
          };

      forceEmptyCache_ = lib.optionalAttrs forceEmptyCache { FORCE_EMPTY_CACHE = true; };
    in
    stdenvNoCC.mkDerivation (
      args
      // {
        inherit name;

        dontUnpack = src == null;
        dontInstall = true;

        nativeBuildInputs = nativeBuildInputs ++ [ prefetch-yarn-deps ];

        buildPhase = ''
          runHook preBuild

          if [[ -f '${yarnLock}' ]]; then
            echo "Using specified ${yarnLock}."
            local -r lockfile=${yarnLock}
          elif [[ -f yarn.lock ]]; then
            echo "Using source supplied yarn.lock."
            local -r lockfile="./yarn.lock"
          else
            echo
            echo "ERROR: No lock file!"
            echo
            echo "yarn.lock is required to build a deterministic cache so that"
            echo "that no suprised changes occur when packages are updated."
            echo
            echo "Hint: You can copy a vendored yarn.lock file via postPatch."
            echo

            exit 1
          fi

          prefetch-yarn-deps $lockfile $out

          runHook postBuild
        '';

        # NIX_NPM_TOKENS environment variable should be a JSON mapping in the shape of:
        # `{ "registry.example.com": "example-registry-bearer-token", ... }`
        impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [ "NIX_NPM_TOKENS" ];

        NIX_NPM_REGISTRY_OVERRIDES = npmRegistryOverridesString;

        SSL_CERT_FILE =
          if
            (
              hash_.outputHash == ""
              || hash_.outputHash == lib.fakeSha256
              || hash_.outputHash == lib.fakeSha512
              || hash_.outputHash == lib.fakeHash
            )
          then
            "${cacert}/etc/ssl/certs/ca-bundle.crt"
          else
            "/no-cert-file.crt";

        outputHashMode = "recursive";
      }
      // hash_
      // forceEmptyCache_
    );

  yarnConfigHook = makeSetupHook {
    name = "yarn-config-hook";
    propagatedBuildInputs = [
      yarn
      fixup-yarn-lock
    ];
    substitutions = {
      # Specify `diff` by abspath to ensure that the user's build
      # inputs do not cause us to find the wrong binaries.
      diff = "${diffutils}/bin/diff";
    };
    meta = {
      description = "Install nodejs dependencies from an offline yarn cache produced by fetchYarnDeps";
    };
  } ./yarn-config-hook.sh;

  yarnBuildHook = makeSetupHook {
    name = "yarn-build-hook";
    meta = {
      description = "Run yarn build in buildPhase";
    };
  } ./yarn-build-hook.sh;

  yarnInstallHook = makeSetupHook {
    name = "yarn-install-hook";
    propagatedBuildInputs = [
      yarn
      nodejsInstallManuals
      nodejsInstallExecutables
    ];
    substitutions = {
      jq = lib.getExe jq;
    };
    meta = {
      description = "Prune yarn dependencies and install files for packages using Yarn 1";
    };
  } ./yarn-install-hook.sh;
}
