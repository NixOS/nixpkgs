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
    version = "1.1.58";

    src = fetchFromGitHub {
      owner = "TDesktop-x64";
      repo = "tdesktop";
      tag = "v${version}";
      hash = "sha256-RHybrvm5p8BUt5StT/NuR76f2y1CCICirTMjdeRLtkY=";
      fetchSubmodules = true;
    };

    patches = [
      (fetchpatch {
        # https://github.com/desktop-app/lib_base/pull/268
        url = "https://github.com/desktop-app/lib_base/commit/c952da37294b958e896b27528e7834f0892faa0a.patch";
        extraPrefix = "Telegram/lib_base/";
        stripLen = 1;
        hash = "sha256-xiq8WLAiSZwpvdyK5JbRAdQ9us93+9oMmeMBqVb1TbI=";
      })
    ];

    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      (lib.cmakeBool "DESKTOP_APP_DISABLE_AUTOUPDATE" true)
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
