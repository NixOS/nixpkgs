{
  lib,
  stdenvNoCC,
  buildNpmPackage,
  fetchFromGitHub,
  fetchzip,
  nix-update,
  nix-update-script,
  writeShellScript,
  curl,
  jq,
  coreutils,
}:
let
  mkBulwarkTheme =
    f:
    let
      fromSource = !((lib.fix f).src ? extension && (lib.fix f).src.extension == "zip");
    in
    stdenvNoCC.mkDerivation (
      finalAttrs:
      let
        attrs = f finalAttrs;
      in
      attrs
      // rec {
        themeName = lib.removePrefix "bulwark-theme-" attrs.pname;

        strictDeps = true;

        installPhase = ''
          runHook preInstall

          install -Dm644 -t $out manifest.json theme.css
          if [ -f "skin.css" ]; then
            install -Dm644 -t $out skin.css
          fi

          runHook postInstall
        '';

        # nix-update cannot discover versions on the extension store, so ask
        # its API for the latest one and let nix-update fix the hashes.
        passthru.updateScript =
          if fromSource then
            nix-update-script { }
          else
            writeShellScript "update-${attrs.pname}" ''
              set -euo pipefail
              version=$(${lib.getExe curl} -sSf https://extensions.bulwarkmail.org/api/v1/extension/${themeName} \
                | ${lib.getExe jq} -r '.data.versions[].version' \
                | ${coreutils}/bin/sort -V | ${coreutils}/bin/tail -n1)
              exec ${lib.getExe nix-update} bulwark-themes.${themeName} --version="$version"
            '';
      }
    );
in
{

  inherit mkBulwarkTheme;

  bolt = mkBulwarkTheme (finalAttrs: {
    pname = "bulwark-theme-bolt";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "themes";
      tag = "bolt@${finalAttrs.version}";
      hash = "sha256-hOcRcRuDv/gKHDZSYw3w8qRMec2JGZkU/7OnTeMRfos=";
    };
    sourceRoot = "${finalAttrs.src.name}/bolt";
    meta = {
      description = "Makes Bulwark look like the Thunderbird desktop app";
      homepage = "https://extensions.bulwarkmail.org/extension/bolt";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
}
