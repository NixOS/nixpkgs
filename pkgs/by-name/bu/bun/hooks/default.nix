{
  lib,
  stdenvNoCC,
  jq,
  moreutils,
  cacert,
  makeSetupHook,
  bun,
  symlinks,
}:
{
  fetchDeps = lib.extendMkDerivation {
    constructDrv = stdenvNoCC.mkDerivation;
    excludeDrvArgNames = [
      "pname"
      "version"
      "workspaces"
      "installFlags"
    ];
    extendDrvArgs =
      finalAttrs:
      {
        workspaces ? [ ],
        preBunInstall ? "",
        installFlags ? [ ],
        os ? [
          "linux"
          "darwin"
          "freebsd"
        ],
        cpu ? [ "*" ],
        ...
      }@args:
      {
        __structuredAttrs = true;
        strictDeps = true;

        name = "${args.pname}-${args.version}-deps";

        nativeBuildInputs = [
          cacert
          jq
          moreutils
          bun
          symlinks
        ]
        ++ args.nativeBuildInputs or [ ];

        buildPhase = ''
          runHook preBuild


          export HOME=$(mktemp -d)
          export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

          ${preBunInstall}

          bun install \
              --force \
              ${lib.concatStringsSep " " (lib.map (package: "--filter=${package}") workspaces)} \
              ${lib.concatStringsSep " " installFlags} \
              ${lib.concatStringsSep " " (lib.map (os: "--os=${os}") os)} \
              ${lib.concatStringsSep " " (lib.map (cpu: "--cpu=${cpu}") cpu)} \
              --ignore-scripts \
              --frozen-lockfile

          # rewrite all symlinks to be relative
          symlinks -cr $BUN_INSTALL_CACHE_DIR

          runHook postBuild
        '';

        # Build a reproducible tarball, per instructions at https://reproducible-builds.org/docs/archives/
        installPhase = ''
          runHook preInstall

          cp -a "$BUN_INSTALL_CACHE_DIR"/. "$out"/

          runHook postInstall
        '';

        dontConfigure = true;
        dontFixup = true;

        outputHashMode = "recursive";
      };
  };
  configHook = makeSetupHook {
    name = "bun-config-hook";
    propagatedBuildInputs = [ bun ];
  } ./bun-config-hook.sh;
}
