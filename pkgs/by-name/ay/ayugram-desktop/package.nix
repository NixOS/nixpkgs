{
  lib,
  stdenv,
  fetchFromGitHub,
  telegram-desktop,
  withWebkit ? true,
}:

telegram-desktop.override {
  pname = "ayugram-desktop";
  inherit withWebkit;
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (
    finalAttrs: previousAttrs: {
      pname = "ayugram-desktop-unwrapped";
      version = "5.8.3";

      src = fetchFromGitHub {
        owner = "AyuGram";
        repo = "AyuGramDesktop";
        tag = "v${finalAttrs.version}";
        hash = "sha256-bgfqYI77kxHmFZB6LCdLzeIFv6bfsXXJrrkbz5MD6Q0=";
        fetchSubmodules = true;
      };

      # Since the original .desktop file is for Flatpak, we need to fix it
      postPatch =
        (previousAttrs.postPatch or "")
        +
          lib.optionalString stdenv.hostPlatform.isLinux
            # Rudiment: related functionality is disabled by disabling the auto-updater
            # and it breaks the .desktop file in Aylur's Gtk Shell
            # (with it, it causes the application to not be seen by the app launcher)
            # https://github.com/AyuGram/AyuGramDesktop/blob/5566a8ca0abe448a7f1865222b64b68ed735ee07/Telegram/SourceFiles/platform/linux/specific_linux.cpp#L455
            ''
              substituteInPlace lib/xdg/com.ayugram.desktop.desktop \
                --replace-fail "DESKTOPINTEGRATION=1 " ""
            ''
        +
          # Since we aren't in Flatpak, "DBusActivatable" has no unit to
          # activate and it causes the .desktop file to show the error "Could not activate remote peer
          # 'com.ayugram.desktop': unit failed" (at least on KDE6)
          ''
            substituteInPlace lib/xdg/com.ayugram.desktop.desktop \
              --replace-fail "DBusActivatable=true" ""
          '';

      meta = previousAttrs.meta // {
        mainProgram = if stdenv.hostPlatform.isLinux then "ayugram-desktop" else "AyuGram";
        description = "Desktop Telegram client with good customization and Ghost mode";
        longDescription = ''
          The best that could be in the world of Telegram clients.
          AyuGram is a Telegram client with a very pleasant features.
        '';
        homepage = "https://github.com/AyuGram/AyuGramDesktop";
        changelog = "https://github.com/AyuGram/AyuGramDesktop/releases/tag/v${finalAttrs.version}";
        maintainers = with lib.maintainers; [ aucub ];
      };
    }
  );
}
