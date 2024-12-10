let
  artifacts = [
    "shell"
    "lua"
    "font"
  ];
in
{
  lib,
  stdenvNoCC,
  fetchurl,
  common-updater-scripts,
  curl,
  jq,
  writeShellScript,
  artifactList ? artifacts,
}:
lib.checkListOfEnum "sketchybar-app-font: artifacts" artifacts artifactList stdenvNoCC.mkDerivation
  (
    finalAttrs:
    let
      selectedSources = map (
        artifact: builtins.getAttr artifact finalAttrs.passthru.sources
      ) artifactList;
    in
    {
      pname = "sketchybar-app-font";
      version = "2.0.18";

      srcs = selectedSources;

      unpackPhase = ''
        runHook preUnpack

        for s in $selectedSources; do
          b=$(basename $s)
          cp $s ''${b#*-}
        done

        runHook postUnpack
      '';

      installPhase =
        ''
          runHook preInstall

        ''
        + lib.optionalString (lib.elem "font" artifactList) ''
          install -Dm644 ${finalAttrs.passthru.sources.font} "$out/share/fonts/truetype/sketchybar-app-font.ttf"

        ''
        + lib.optionalString (lib.elem "shell" artifactList) ''
          install -Dm755 ${finalAttrs.passthru.sources.shell} "$out/bin/icon_map.sh"

        ''
        + lib.optionalString (lib.elem "lua" artifactList) ''
          install -Dm644 ${finalAttrs.passthru.sources.lua} "$out/lib/sketchybar-app-font/icon_map.lua"

          runHook postInstall
        '';

      passthru = {
        sources = {
          font = fetchurl {
            url = "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v${finalAttrs.version}/sketchybar-app-font.ttf";
            hash = "sha256-ajwyBUfgvIUcac8gdFUnzGJCXsUcOJnscIdtrxo7ZqY=";
          };
          lua = fetchurl {
            url = "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v${finalAttrs.version}/icon_map.lua";
            hash = "sha256-jxIBLE1UDD1S8nu4b9y7AUYb0XHH/3iknhmBloi1Qrs=";
          };
          shell = fetchurl {
            url = "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v${finalAttrs.version}/icon_map.sh";
            hash = "sha256-I0t9KbC3Cs73021z9lm7TZUhmwdIaIgPVuLe8IjwkCU=";
          };
        };

        updateScript = writeShellScript "update-sketchybar-app-font" ''
          set -o errexit
          export PATH="${
            lib.makeBinPath [
              curl
              jq
              common-updater-scripts
            ]
          }"
          NEW_VERSION=$(curl --silent https://api.github.com/repos/kvndrsslr/sketchybar-app-font/releases/latest | jq '.tag_name | ltrimstr("v")' --raw-output)
          if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
              echo "The new version same as the old version."
              exit 0
          fi
          for artifact in ${
            lib.escapeShellArgs (lib.mapAttrsToList (a: _: a) finalAttrs.passthru.sources)
          }; do
            update-source-version "sketchybar-app-font" "0" "${lib.fakeHash}" --source-key="sources.$artifact"
            update-source-version "sketchybar-app-font" "$NEW_VERSION" --source-key="sources.$artifact"
          done
        '';
      };

      meta = {
        description = "A ligature-based symbol font and a mapping function for sketchybar";
        longDescription = ''
          A ligature-based symbol font and a mapping function for sketchybar, inspired by simple-bar's usage of community-contributed minimalistic app icons.
        '';
        homepage = "https://github.com/kvndrsslr/sketchybar-app-font";
        license = lib.licenses.cc0;
        maintainers = with lib.maintainers; [ khaneliman ];
      };
    }
  )
