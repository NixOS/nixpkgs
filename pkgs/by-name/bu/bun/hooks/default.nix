{
  lib,
  stdenvNoCC,
  makeSetupHook,
  pkg-config,
  cacert,
  bun,
  curl,
  rustPlatform,
}:

let
  prefetch-bun-deps = rustPlatform.buildRustPackage {
    pname = "prefetch-bun-deps";
    version = (lib.importTOML ./Cargo.toml).package.version;

    src = lib.sourceFilesBySuffices ./. [
      ".rs"
      ".toml"
      ".lock"
    ];

    cargoLock.lockFile = ./Cargo.lock;

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ curl ];

    meta = {
      description = "Prefetch dependencies from bun (for use with `bun.fetchDeps`)";
      mainProgram = "prefetch-bun-deps";
      maintainers = with lib.maintainers; [ eveeifyeve ];
      license = lib.licenses.mit;
    };
  };
in
{
  prefetch-bun-deps = prefetch-bun-deps;

  fetchDeps = lib.extendMkDerivation {
    constructDrv = stdenvNoCC.mkDerivation;
    excludeDrvArgNames = [
      "hash"
      "workspaces"
    ];
    extendDrvArgs =
      _finalAttrs:
      {
        pname,
        version,
        hash ? "",
        workspaces ? [ ],
        ...
      }@args:
      let
        hash_ =
          if hash != "" then
            {
              outputHash = hash;
            }
          else
            {
              outputHash = "";
              outputHashAlgo = "sha256";
            };

        # The fetcher downloads the whole lockfile, so workspaces do not
        # influence the output; they are only used by `bun.configHook`.
      in
      {
        name = "${pname}-${version}-bun-deps";

        __structuredAttrs = true;
        strictDeps = true;
        enableParallelBuilding = args.enableParallelBuilding or true;

        nativeBuildInputs = [ prefetch-bun-deps ] ++ (args.nativeBuildInputs or [ ]);

        buildPhase = ''
          runHook preBuild

          prefetch-bun-deps "$src" "$out"

          runHook postBuild
        '';

        dontInstall = true;
        dontConfigure = true;
        dontFixup = true;

        impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
          "GIT_PROXY_COMMAND"
          "SOCKS_SERVER"
        ];

        env.SSL_CERT_FILE =
          if (hash == "" || hash == lib.fakeHash || hash == lib.fakeSha256 || hash == lib.fakeSha512) then
            "${cacert}/etc/ssl/certs/ca-bundle.crt"
          else
            "/no-cert-file.crt";

        outputHashMode = "recursive";
      }
      // hash_;
  };

  configHook = makeSetupHook {
    name = "bun-config-hook";
    propagatedBuildInputs = [
      bun
      prefetch-bun-deps
    ];
  } ./bun-config-hook.sh;
}
