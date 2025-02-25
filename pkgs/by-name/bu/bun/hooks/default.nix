{
  lib,
  stdenvNoCC,
  jq,
  moreutils,
  cacert,
  makeSetupHook,
  bun,
}:

{
  fetchDeps = lib.makeOverridable (
    lib.fetchers.withNormalizedHash { } (
      {
        name ?
          lib.optionalString (args ? "pname" && args ? "version") "${args.pname}-${args.version}-"
          + "bun-deps",
        workspaces ? [ ],
        preInstall ? "",
        installFlags ? [ ],
        outputHash,
        outputHashAlgo,
        ...
      }@args:
      let
        args' = builtins.removeAttrs args [
          "pname"
          "version"
          "workspaces"
          "preInstall"
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
          ] ++ args'.nativeBuildInputs or [ ];

          installPhase =
            args.installPhase or ''
              runHook preInstall

              export HOME=$(mktemp -d)
              export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

              ${preInstall}

              bun install \
                  --force \
                  ${lib.escapeShellArgs (lib.map (package: "--filter=${package}") workspaces)} \
                  ${lib.escapeShellArgs installFlags} \
                  --frozen-lockfile

              runHook postInstall
            '';

          # Build a reproducible tarball, per instructions at https://reproducible-builds.org/docs/archives/
          fixupPhase =
            args.fixupPhase or ''
              runHook preFixup

              tar --sort-name \
                --mtime="@$SOURCE_DATE_EPOCH" \
                --owner=0 --group=0 --numeric-owner \
                --pax-option=exthdr.name=%d/PaxHeaders/%f,delete=atime,delete=ctime \
                -czf $out $BUN_INSTALL_CACHE_DIR

                runHook postFixup
            '';

          dontConfigure = args'.dontConfigure or true;
          dontBuild = args'.dontBuild or true;

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
