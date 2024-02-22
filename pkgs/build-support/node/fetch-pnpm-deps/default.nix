{ lib
, stdenvNoCC
, nodePackages
, jq
, moreutils
, cacert
, makeSetupHook
}: {
  fetchPnpmDeps =
    { src
    , hash ? ""
    , pname
    , pnpm ? nodePackages.pnpm
    , ...
    } @ args:
    let
      args' = builtins.removeAttrs args [ "hash" "pname" "pnpm" "supportedArchitectures" ];
      hash' =
        if hash != "" then {
          outputHash = hash;
        } else {
          outputHash = "";
          outputHashAlgo = "sha256";
        };
    in
    # NOTE: This requires pnpm 8.10.0 or newer
      # https://github.com/pnpm/pnpm/pull/7214
    assert lib.versionAtLeast pnpm.version "8.10.0";
    stdenvNoCC.mkDerivation (args' // {
      name = "${pname}-pnpm-deps";

      nativeBuildInputs = [
        jq
        moreutils
        pnpm
        cacert
      ];

      # https://github.com/NixOS/nixpkgs/blob/763e59ffedb5c25774387bf99bc725df5df82d10/pkgs/applications/misc/pot/default.nix#L56
      installPhase = ''
        runHook preInstall

        export HOME=$(mktemp -d)
        pnpm config set store-dir $out
        # pnpm is going to warn us about using --force
        # --force allows us to fetch all dependencies including ones that aren't meant for our host platform
        pnpm install --frozen-lockfile --ignore-script --force

        runHook postInstall
      '';

      fixupPhase = ''
        runHook preFixup

        rm -rf $out/v3/tmp
        for f in $(find $out -name "*.json"); do
          sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
          jq --sort-keys . $f | sponge $f
        done

        runHook postFixup
      '';

      dontConfigure = true;
      dontBuild = true;
      outputHashMode = "recursive";
    } // hash');

  pnpmConfigHook = makeSetupHook
    {
      name = "pnpm-config-hook";
    } ./pnpm-config-hook.sh;
}
