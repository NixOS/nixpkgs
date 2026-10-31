{
  lib,
  stdenvNoCC,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:

/**
  `mkProtonBinDerivation` is a helper builder for prebuilt Proton (and other
  Steam compatibility tool) releases, for use with
  `programs.steam.extraCompatPackages`.

  # Inputs

    `attrs`
    : attrs for stdenvNoCC.mkDerivation, plus:

      `passthru.variants`
      : an attrset mapping each supported system to `{ src; toolName; }`, where
        `toolName` is the name used in the release's `compatibilitytool.vdf`

      `steamDisplayName`
      : the name shown in Steam, overridable using `overrideAttrs`

      `passthru.latestVersionCommand`
      : optional shell snippet printing the latest upstream version, with `curl` and `jq`
        available. When set, a `passthru.updateScript` is provided which updates the
        `src` of every variant to that version

  # Example
  ```nix
  { mkProtonBinDerivation, fetchzip }:

  mkProtonBinDerivation (finalAttrs: {
    pname = "proton-example-bin";
    version = "Proton-Example-1";
    steamDisplayName = "Proton-Example";

    passthru = {
      variants = {
        "x86_64-linux" = {
          toolName = "${finalAttrs.version}-x86_64";
          src = fetchzip {
            url = "https://example.org/${finalAttrs.version}-x86_64.tar.gz";
            hash = "...";
          };
        };
      };

      latestVersionCommand = ''
        curl -fsSL https://example.org/releases.json | jq -er '.[0].tag_name'
      '';
    };
  })
  ```
*/

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  extendDrvArgs =
    finalAttrs:
    {
      passthru ? { },
      meta ? { },
      ...
    }@args:
    {
      steamDisplayName = args.steamDisplayName or finalAttrs.pname;

      inherit (finalAttrs.passthru.variants.${stdenvNoCC.hostPlatform.system}) src toolName;

      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;

      outputs = [
        "out"
        "steamcompattool"
      ];

      installPhase = ''
        runHook preInstall

        # Make it impossible to add to an environment. You should use the appropriate NixOS option.
        # Also leave some breadcrumbs in the file.
        echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

        mkdir $steamcompattool
        ln -s $src/* $steamcompattool
        rm $steamcompattool/compatibilitytool.vdf
        cp $src/compatibilitytool.vdf $steamcompattool

        runHook postInstall
      '';

      preFixup = ''
        substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
          --replace-fail "$toolName" "$steamDisplayName"
      '';

      passthru =
        lib.optionalAttrs (passthru ? latestVersionCommand) {
          updateScript = writeShellScript "update-${finalAttrs.pname}" ''
            set -euo pipefail
            export PATH=${
              lib.makeBinPath [
                curl
                jq
                common-updater-scripts
              ]
            }:$PATH

            version="$(${finalAttrs.passthru.latestVersionCommand})"
            if [[ -z "$version" || "$version" == null ]]; then
              echo "${finalAttrs.pname}: could not determine the latest version" >&2
              exit 1
            fi
            if [[ "$version" == ${lib.escapeShellArg finalAttrs.version} ]]; then
              echo "${finalAttrs.pname}: already at the latest version $version" >&2
              exit 0
            fi

            for variant in ${lib.escapeShellArgs (builtins.attrNames finalAttrs.passthru.variants)}; do
              update-source-version "''${UPDATE_NIX_ATTR_PATH:-${finalAttrs.pname}}" "$version" \
                --ignore-same-version --source-key="variants.$variant.src"
            done
          '';
        }
        // passthru;

      meta = {
        platforms = builtins.attrNames finalAttrs.passthru.variants;
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      }
      // meta;
    };
}
