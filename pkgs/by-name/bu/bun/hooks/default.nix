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
  fetchDeps =
    {
      hash ? "",
      pname,
      workspaces ? [ ],
      preInstall ? "",
      installFlags ? [ ],
      ...
    }@args:
    let
      args' = builtins.removeAttrs args [
        "hash"
        "pname"
      ];
    in
    stdenvNoCC.mkDerivation (
      finalAttrs:
      (
        args'
        // {
          name = "${pname}-bun-deps";

          nativeBuildInputs = [
            cacert
            jq
            moreutils
            bun
          ] ++ args'.nativeBuildInputs;

          installPhase = ''
            runHook preInstall

            export HOME=$(mktemp -d)
            export BUN_INSTALL_CACHE_DIR=$out

            ${preInstall}

            bun install \
                --force \
                ${lib.escapeShellArgs (lib.map (package: "--filter=${package}") workspaces)} \
                ${lib.escapeShellArgs installFlags} \
                --frozen-lockfile

            runHook postInstall
          '';

          fixupPhase = ''
            runHook preFixup

            # Remove timestamp and sort the json files
            #   rm -rf $out/v3/tmp
            #   for f in $(find $out -name "*.json"); do
            #     jq --sort-keys "del(.. | .checkedAt?)" $f | sponge $f
            #   done

              runHook postFixup
          '';

          dontConfigure = true;
          dontBuild = true;

          outputHash = hash;
          outputHashMode = "recursive";
        }
        // lib.optionalAttrs (hash == "") {
          outputHashAlgo = "sha256";
        }
      )
    );

  configHook = makeSetupHook {
    name = "bun-config-hook";
    propagatedBuildInputs = [ bun ];
  } ./bun-config-hook.sh;
}
