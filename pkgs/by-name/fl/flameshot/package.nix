{ libsForQt5
, stdenv
, lib
, fetchFromGitHub
, cmake
, nix-update-script
, fetchpatch
}:

stdenv.mkDerivation {
  pname = "flameshot";
  version = "12.1.0-unstable-2024-07-02";

  src = fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "ccb5a27b136a633911b3b1006185530d9beeea5d";
    hash = "sha256-JIXsdVUR/4183aJ0gvNGYPTyCzX7tCrk8vRtR8bcdhE=";
  };

  patches = [
    # https://github.com/flameshot-org/flameshot/pull/3166
    # fixes fractional scaling calculations on wayland
    (fetchpatch {
      name = "10-fix-wayland.patch";
      url = "https://github.com/flameshot-org/flameshot/commit/5fea9144501f7024344d6f29c480b000b2dcd5a6.patch";
      hash = "sha256-SnjVbFMDKD070vR4vGYrwLw6scZAFaQA4b+MbI+0W9E=";
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  cmakeFlags = [
    (lib.cmakeBool "USE_WAYLAND_CLIPBOARD" true)
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.qttools
    libsForQt5.qtsvg
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.kguiaddons
  ];

  meta = with lib; {
    description = "Powerful yet simple to use screenshot software";
    homepage = "https://github.com/flameshot-org/flameshot";
    mainProgram = "flameshot";
    maintainers = with maintainers; [ scode oxalica ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
