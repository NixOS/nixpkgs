{ lib
, stdenv
, fetchFromGitHub
, telegram-desktop
, nix-update-script
}:

telegram-desktop.overrideAttrs (old: rec {
  pname = "64gram";
  version = "1.1.24";

  src = fetchFromGitHub {
    owner = "TDesktop-x64";
    repo = "tdesktop";
    rev = "v${version}";

    fetchSubmodules = true;
    hash = "sha256-pAtV/uKWCh9sODCYXf6gM8B0i2o5OiVH7z2iLjIZKP0=";
  };

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "Unofficial Telegram Desktop providing Windows 64bit build and extra features";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    homepage = "https://github.com/TDesktop-x64/tdesktop";
    changelog = "https://github.com/TDesktop-x64/tdesktop/releases/tag/v${version}";
    maintainers = with maintainers; [ clot27 ];
    mainProgram = "telegram-desktop";
    broken = stdenv.isDarwin;
  };
})
