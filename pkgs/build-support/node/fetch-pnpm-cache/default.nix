{
  cacert,
  lib,
  makeSetupHook,
  mitm-cache,
  pnpm,
  pnpm-fetch-cache,
  stdenvNoCC,
  writableTmpDirAsHomeHook,
}:
{
  fetchPnpmCache = lib.extendMkDerivation {
    constructDrv = stdenvNoCC.mkDerivation;
    excludeDrvArgNames = [
      "pname"
      "hash"
      "pnpmRoot"
    ];
    extendDrvArgs =
      finalAttrs:
      args@{
        pname,
        hash ? "",
        pnpmRoot ? ".",
        ...
      }:
      {
        name = "${pname}-pnpm-cache";

        nativeBuildInputs = args.nativeBuildInputs or [ ] ++ [
          cacert
          pnpm-fetch-cache
        ];

        impureEnvVars = args.impureEnvVars or [ ] ++ lib.fetchers.proxyImpureEnvVars;

        inherit pnpmRoot;

        installPhase = ''
          runHook preInstall

          pnpm-fetch-cache --path "$pnpmRoot" --outputPath "$out"

          install -Dm644 -t "$out/nix" "$pnpmRoot/pnpm-lock.yaml"

          runHook postInstall
        '';

        dontConfigure = true;
        dontBuild = true;
        dontFixup = true;
        outputHashMode = "recursive";
        outputHash = hash;
        __structuredAttrs = true;
        strictDeps = true;
      };
  };

  pnpmCacheConfigHook = makeSetupHook {
    name = "pnpm-cache-config-hook";
    propagatedBuildInputs = [
      writableTmpDirAsHomeHook
      mitm-cache
    ];
    substitutions = {
      npmArch = stdenvNoCC.targetPlatform.node.arch;
      npmPlatform = stdenvNoCC.targetPlatform.node.platform;
    };

    __structuredAttrs = true;

    meta = {
      license = lib.licenses.mit;
      inherit (pnpm.meta) maintainers;
    };
  } ./pnpm-cache-config-hook.sh;
}
