{
  lib,
  fetchFromGitHub,
  telegram-desktop,
  withWebkit ? true,
}:

let
  version = "1.4.9";
in
telegram-desktop.override {
  pname = "kotatogram-desktop";
  inherit withWebkit;
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (old: {
    pname = "kotatogram-desktop-unwrapped";
    version = "${version}-unstable-2026-10-06";

    src = fetchFromGitHub {
      owner = "kotatogram";
      repo = "kotatogram-desktop";
      rev = "4561e1a33bb55feb692282d8ae5ba1bf6f7a72f3";
      hash = "sha256-P+EDqXzRokgBmf6xbu9g/2wgKfUPKps/GQSXUXojlNI=";
      fetchSubmodules = true;
    };

    meta = {
      description = "Kotatogram – experimental Telegram Desktop fork";
      longDescription = ''
        Unofficial desktop client for the Telegram messenger, based on Telegram Desktop.

        It contains some useful (or purely cosmetic) features, but they could be unstable. A detailed list is available here: https://kotatogram.github.io/changes
      '';
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.all;
      homepage = "https://kotatogram.github.io";
      changelog = "https://github.com/kotatogram/kotatogram-desktop/releases/tag/k${version}";
      maintainers = with lib.maintainers; [ ilya-fedin ];
      mainProgram = "Kotatogram";
    };
  });
}
