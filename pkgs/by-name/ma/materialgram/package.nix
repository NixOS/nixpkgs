{
  telegram-desktop,
  lib,
  xdg-utils,
  stdenv,
  fetchFromGitHub,
}:
telegram-desktop.overrideAttrs (
  finalAttrs: previousAttrs: {
    pname = "materialgram";
    version = "5.1.7.1";

    src = fetchFromGitHub {
      owner = "kukuruzka165";
      repo = "materialgram";
      rev = "v${finalAttrs.version}";
      fetchSubmodules = true;
      hash = "sha256-OlXcDsjZ59/GjysfFAOo6dAoNnUY5hBD9NuNgTR4rXc=";
    };

    postFixup =
      lib.optionalString stdenv.isLinux ''
        # This is necessary to run Telegram in a pure environment.
        # We also use gappsWrapperArgs from wrapGAppsHook.
        wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
          "''${gappsWrapperArgs[@]}" \
          "''${qtWrapperArgs[@]}" \
          --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
      ''
      + lib.optionalString stdenv.isDarwin ''
        wrapQtApp $out/Applications/${finalAttrs.meta.mainProgram}.app/Contents/MacOS/${finalAttrs.meta.mainProgram}
      '';

    meta = previousAttrs.meta // {
      description = "Telegram Desktop fork with material icons and some improvements";
      longDescription = ''
        Telegram Desktop fork with Material Design and other improvements,
        which is based on the Telegram API and the MTProto secure protocol.
      '';
      homepage = "https://kukuruzka165.github.io/materialgram/";
      changelog = "https://github.com/kukuruzka165/materialgram/releases/tag/v${finalAttrs.version}";
      maintainers = with lib.maintainers; [
        oluceps
        aleksana
      ];
      mainProgram = "materialgram";
    };
  }
)
