{ lib
, stdenv
, fetchFromGitHub
, telegram-desktop
}:

telegram-desktop.overrideAttrs (old: rec {

  pname = "64Gram";
  version = "1.1.15";

  src = fetchFromGitHub {
    owner = "TDesktop-x64";
    repo = "tdesktop";
    rev = "v${version}";

    fetchSubmodules = true;
    hash = "sha256-3HLRv8RTyyfnjMF7w+euSOj6SbxlxOuczap5Nlizsvg=";
  };

  meta = with lib; {
    description = "An unofficial Telegram Desktop providing Windows 64bit build and extra features";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    homepage = "https://github.com/TDesktop-x64/tdesktop";
    changelog = "https://github.com/TDesktop-x64/tdesktop/releases/tag/v${version}";
    maintainers = with maintainers; [ clot27 ];
    mainProgram = "telegram-desktop";
    broken = stdenv.isDarwin;
  };
})
