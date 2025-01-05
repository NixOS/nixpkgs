{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libsForQt5,
  yasm,
  withWebkit ? true,
}:

let
  telegram-desktop = libsForQt5.callPackage ../telegram-desktop { inherit stdenv; };
  version = "1.4.9";
  tg_owt = telegram-desktop.tg_owt.overrideAttrs (oldAttrs: {
    version = "0-unstable-2024-06-15";

    src = fetchFromGitHub {
      owner = "desktop-app";
      repo = "tg_owt";
      rev = "c9cc4390ab951f2cbc103ff783a11f398b27660b";
      hash = "sha256-FfWmSYaeryTDbsGJT3R7YK1oiyJcrR7YKKBOF+9PmpY=";
      fetchSubmodules = true;
    };

    patches = (oldAttrs.patches or [ ]) ++ [
      (fetchpatch {
        url = "https://webrtc.googlesource.com/src/+/e7d10047096880feb5e9846375f2da54aef91202%5E%21/?format=TEXT";
        decode = "base64 -d";
        stripLen = 1;
        extraPrefix = "src/";
        hash = "sha256-goxnuRRbwcdfIk1jFaKGiKCTCYn2saEj7En1Iyglzko=";
      })
    ];

    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ yasm ];
  });
in
telegram-desktop.override {
  pname = "kotatogram-desktop";
  inherit withWebkit;
  unwrapped = (telegram-desktop.unwrapped.override { inherit tg_owt; }).overrideAttrs {
    pname = "kotatogram-desktop-unwrapped";
    version = "${version}-unstable-2024-09-27";

    src = fetchFromGitHub {
      owner = "kotatogram";
      repo = "kotatogram-desktop";
      rev = "0581eb6219343b3cfcbb81124b372df1039b7568";
      hash = "sha256-rvn8GZmHdMkVutLUe/LmUNIawlb9VgU3sYhPwZ2MWsI=";
      fetchSubmodules = true;
    };

    patches = [
      ./macos-qt5.patch
      (fetchpatch {
        url = "https://gitlab.com/mnauw/cppgir/-/commit/c8bb1c6017a6f7f2e47bd10543aea6b3ec69a966.patch";
        stripLen = 1;
        extraPrefix = "cmake/external/glib/cppgir/";
        hash = "sha256-8B4h3BTG8dIlt3+uVgBI569E9eCebcor9uohtsrZpnI=";
      })
    ];

    meta = with lib; {
      description = "Kotatogram – experimental Telegram Desktop fork";
      longDescription = ''
        Unofficial desktop client for the Telegram messenger, based on Telegram Desktop.

        It contains some useful (or purely cosmetic) features, but they could be unstable. A detailed list is available here: https://kotatogram.github.io/changes
      '';
      license = licenses.gpl3Only;
      platforms = platforms.all;
      homepage = "https://kotatogram.github.io";
      changelog = "https://github.com/kotatogram/kotatogram-desktop/releases/tag/k${version}";
      maintainers = with maintainers; [ ilya-fedin ];
      mainProgram = if stdenv.hostPlatform.isLinux then "kotatogram-desktop" else "Kotatogram";
    };
  };
}
