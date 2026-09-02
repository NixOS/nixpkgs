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
    version = "${version}-unstable-2026-07-03";

    src = fetchFromGitHub {
      owner = "kotatogram";
      repo = "kotatogram-desktop";
      rev = "7263a1b53c9e6b45a416532644fff7a4c7f90d54";
      hash = "sha256-xOfHZ7oUJKk65j7o/AgxtFfc5NqsAoA9E+8U6rHlSmc=";
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
