{
  lib,
  fetchFromGitHub,
  telegram-desktop,
  withWebkit ? true,
}:

telegram-desktop.override {
  pname = "64gram";
  inherit withWebkit;
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (old: rec {
    pname = "64gram-unwrapped";
    version = "1.2.5";

    src = fetchFromGitHub {
      owner = "TDesktop-x64";
      repo = "tdesktop";
      tag = "v${version}";
      hash = "sha256-CcYcdSgeVEbGKOzim+Q/gIxMIfDGaSStF4cLLttA+SM=";
      fetchSubmodules = true;
    };

    # Newer 64gram releases include this file. Qt 6.11 dropped the edit
    # menu roles, and keeps those actions working through TextHeuristicRole.
    postPatch = (old.postPatch or "") + ''
      if [ -f Telegram/SourceFiles/platform/mac/global_menu_mac.mm ]; then
        substituteInPlace Telegram/SourceFiles/platform/mac/global_menu_mac.mm \
          --replace-fail '#if QT_VERSION >= QT_VERSION_CHECK(6, 8, 0)' \
                         '#if QT_VERSION >= QT_VERSION_CHECK(6, 8, 0) && QT_VERSION < QT_VERSION_CHECK(6, 11, 0)'
      fi
    '';

    meta = {
      description = "Unofficial Telegram Desktop providing Windows 64bit build and extra features";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.all;
      homepage = "https://github.com/TDesktop-x64/tdesktop";
      changelog = "https://github.com/TDesktop-x64/tdesktop/releases/tag/v${version}";
      maintainers = with lib.maintainers; [ clot27 ];
      mainProgram = "Telegram";
    };
  });
}
