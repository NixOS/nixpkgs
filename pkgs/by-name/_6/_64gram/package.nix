{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  telegram-desktop,
  withWebkit ? true,
}:

telegram-desktop.override {
  pname = "64gram";
  inherit withWebkit;
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (old: rec {
    pname = "64gram-unwrapped";
    version = "1.1.45";

    src = fetchFromGitHub {
      owner = "TDesktop-x64";
      repo = "tdesktop";
      rev = "v${version}";
      hash = "sha256-bDe4tmJRWnussa5QrBh2oStvIF7R5/nbPfljb3us3nk=";
      fetchSubmodules = true;
    };

    patches = (old.patches or [ ]) ++ [
      (fetchpatch {
        url = "https://github.com/TDesktop-x64/tdesktop/commit/c996ccc1561aed089c8b596f6ab3844335bbf1df.patch";
        revert = true;
        hash = "sha256-Hz7BXl5z4owe31l9Je3QOXT8FAyKcbsXsKjGfCmXhzE=";
      })
    ];

    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      (lib.cmakeBool "DESKTOP_APP_DISABLE_AUTOUPDATE" true)
      (lib.cmakeBool "disable_autoupdate" true)
    ];

    meta = {
      description = "Unofficial Telegram Desktop providing Windows 64bit build and extra features";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.all;
      homepage = "https://github.com/TDesktop-x64/tdesktop";
      changelog = "https://github.com/TDesktop-x64/tdesktop/releases/tag/v${version}";
      maintainers = with lib.maintainers; [ clot27 ];
      mainProgram = if stdenv.hostPlatform.isLinux then "telegram-desktop" else "Telegram";
    };
  });
}
