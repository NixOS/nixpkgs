{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, callPackage
, libsForQt5
, yasm
}:

(libsForQt5.callPackage ../telegram-desktop/default.nix {
  inherit stdenv;

  tg_owt = (callPackage ../telegram-desktop/tg_owt.nix {
    # tg_owt should use the same compiler
    inherit stdenv;
  }).overrideAttrs(oldAttrs: {
    version = "0-unstable-2024-06-15";

    src = fetchFromGitHub {
      owner = "desktop-app";
      repo = "tg_owt";
      rev = "c9cc4390ab951f2cbc103ff783a11f398b27660b";
      hash = "sha256-FfWmSYaeryTDbsGJT3R7YK1oiyJcrR7YKKBOF+9PmpY=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ yasm ];
  });

  withWebKitGTK = false;
}).overrideAttrs {
  pname = "kotatogram-desktop";
  version = "1.4.9-unstable-2024-09-27";

  src = fetchFromGitHub {
    owner = "kotatogram";
    repo = "kotatogram-desktop";
    rev = "0581eb6219343b3cfcbb81124b372df1039b7568";
    hash = "sha256-rvn8GZmHdMkVutLUe/LmUNIawlb9VgU3sYhPwZ2MWsI=";
    fetchSubmodules = true;
  };

  patches = [
    ./macos.patch
    ./macos-opengl.patch
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
    changelog = "https://github.com/kotatogram/kotatogram-desktop/releases/tag/k{version}";
    maintainers = with maintainers; [ ilya-fedin ];
    mainProgram = if stdenv.hostPlatform.isLinux then "kotatogram-desktop" else "Kotatogram";
  };
}
