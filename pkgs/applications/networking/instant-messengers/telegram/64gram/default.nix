{ telegram-desktop, fetchFromGitHub, lib, ... }:

telegram-desktop.overrideAttrs (old: rec {

  pname = "64Gram";
  version = "1.1.14";

  src = fetchFromGitHub {
    owner = "TDesktop-x64";
    repo = "tdesktop";
    rev = "v${version}";

    fetchSubmodules = true;
    hash = "sha256-+Cx4qh/zHyBYRBxeZLZATU2U/r8xF24R8AXnfFwl+Oo=";
  };

  meta = with lib; {
    description = "64Gram (unofficial Telegram Desktop)";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    homepage = "https://github.com/TDesktop-x64/tdesktop";
    changelog = "https://github.com/TDesktop-x64/tdesktop/releases/tag/v${version}";
    maintainers = with maintainers; [ clot27 ];
  };
})
