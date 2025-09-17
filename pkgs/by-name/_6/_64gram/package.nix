{
  lib,
  stdenv,
  fetchFromGitHub,
  telegram-desktop,
  alsa-lib,
  jemalloc,
  libopus,
  libpulseaudio,
  withWebkit ? true,
}:

telegram-desktop.override {
  pname = "64gram";
  inherit withWebkit;
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (old: rec {
    pname = "64gram-unwrapped";
    version = "1.1.78";

    src = fetchFromGitHub {
      owner = "TDesktop-x64";
      repo = "tdesktop";
      tag = "v${version}";
      hash = "sha256-3iMDkosa19iVd3b1dS+xONZZokFnvjuehHFN05NsCTY=";
      fetchSubmodules = true;
    };

    buildInputs = (old.buildInputs or [ ]) ++ [
      alsa-lib
      jemalloc
      libopus
      libpulseaudio
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
