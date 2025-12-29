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
  fetchDeps = lib.makeOverridable (
    lib.fetchers.withNormalizedHash { } (
      {
        name ?
          lib.optionalString (args ? "pname" && args ? "version") "${args.pname}-${args.version}-"
          + "bun-deps.tar.gz",
        workspaces ? [ ],
        installFlags ? [ ],
        os ? [
          "linux"
          "darwin"
          "freebsd"
        ],
        cpu ? [ "*" ],
        outputHash,
        outputHashAlgo,
        ...
      }@args:
      let
        args' = builtins.removeAttrs args [
          "pname"
          "version"
          "workspaces"
          "installFlags"
        ];
      in
      stdenvNoCC.mkDerivation (
        args'
        // {
          inherit name;

          nativeBuildInputs = [
            cacert
            jq
            moreutils
            bun
            symlinks
          ]
          ++ args'.nativeBuildInputs or [ ];

          buildPhase =
            args.buildPhase or ''
              export HOME=$(mktemp -d)
              export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

              runHook preBuild

              bun install \
                  --force \
                  ${lib.escapeShellArgs (lib.map (package: "--filter=${package}") workspaces)} \
                  ${lib.escapeShellArgs (lib.map (os: "--os=${os}") os)} \
                  ${lib.escapeShellArgs (lib.map (cpu: "--cpu=${cpu}") cpu)} \
                  ${lib.escapeShellArgs installFlags} \
                  --ignore-scripts \
                  --frozen-lockfile

              # rewrite all symlinks to be relative
              symlinks -cr $BUN_INSTALL_CACHE_DIR

              runHook postBuild
            '';

          # Build a reproducible tarball, per instructions at https://reproducible-builds.org/docs/archives/
          installPhase =
            args.installPhase or ''
              runHook preInstall

              tar --sort=name \
                --mtime="@$SOURCE_DATE_EPOCH" \
                --owner=0 --group=0 --numeric-owner \
                --pax-option=exthdr.name=%d/PaxHeaders/%f,delete=atime,delete=ctime \
                -czf $out -C $BUN_INSTALL_CACHE_DIR .

              runHook postInstall
            '';

          dontConfigure = args'.dontConfigure or true;
          dontFixup = args'.dontFixup or true;

          inherit outputHash outputHashAlgo;
          outputHashMode = "recursive";
        }
      )
    )
  );

  configHook = makeSetupHook {
    name = "bun-config-hook";
    propagatedBuildInputs = [ bun ];
  } ./bun-config-hook.sh;
}
