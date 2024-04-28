{
  stdenv,
  lib,
  fetchFromGitHub,
  telegram-desktop,
  # AyuGram doesn't have its own API keys, so these are provided by @duvetfall.
  apiId ? 20393039,
  apiHash ? "c18dc825962eef0b528a4ccd9482c14f"
}:
let
  mainProgram = if stdenv.isLinux then "ayugram-desktop" else "Ayugram";
in
(telegram-desktop.override { inherit mainProgram apiId apiHash; }).overrideAttrs (
  finalAttrs: previousAttrs: {
    pname = "ayugram-desktop";
    version = "4.16.8";

    src = fetchFromGitHub {
      owner = "AyuGram";
      repo = "AyuGramDesktop";
      rev = "v${finalAttrs.version}";
      fetchSubmodules = true;
      hash = "sha256-HrvqENRRyRzTDUUgzAHPBwNVo5dDTUsGIFOH75RQes0=";
    };

    # Since the original .desktop file is for Flatpak, we need to fix it.
    postInstall =
      lib.optionalString stdenv.isLinux
        # Rudiment: related functionality is disabled by disabling the auto-updater
        # and it breaks the .desktop file in Aylur's Gtk Shell
        # (with it, it causes the application to not be seen by the app launcher).
        # https://github.com/AyuGram/AyuGramDesktop/blob/5566a8ca0abe448a7f1865222b64b68ed735ee07/Telegram/SourceFiles/platform/linux/specific_linux.cpp#L455
        ''
          substituteInPlace $out/share/applications/com.ayugram.desktop.desktop \
            --replace-fail 'Exec=DESKTOPINTEGRATION=1 ' 'Exec='
        ''
      +
        # Since we aren't in Flatpak, "DBusActivatable" has no unit to
        # activate and it causes the .desktop file to show the error "Could not activate remote peer
        # 'com.ayugram.desktop': unit failed" (at least on KDE6).
        ''
          substituteInPlace $out/share/applications/com.ayugram.desktop.desktop \
            --replace-fail 'DBusActivatable=true' '# DBusActivatable=true'
        '';

    meta = {
      description = "A desktop Telegram client with great customization and Ghost mode";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.all;
      homepage = "https://github.com/AyuGram/AyuGramDesktop";
      changelog = "https://github.com/AyuGram/AyuGramDesktop/blob/v${finalAttrs.version}/changelog.txt";
      maintainers = with lib.maintainers; [ duvetfall ];
      inherit mainProgram;
    };
  }
)
