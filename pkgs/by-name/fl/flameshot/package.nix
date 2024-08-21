{ libsForQt5
, stdenv
, lib
, fetchFromGitHub
, cmake
, nix-update-script
, fetchpatch
, grim
, makeBinaryWrapper
, enableWlrSupport ? false
}:

stdenv.mkDerivation {
  pname = "flameshot";
  # wlr screenshotting is currently only available on unstable version (>12.1.0)
  version = "12.1.0-unstable-2024-08-02";

  src = fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "fd3772e2abb0b852573fcaa549ba13517f13555c";
    hash = "sha256-WXUxrirlevqJ+dnXZbN1C1l5ibuSI/DBi5fqPx9nOGQ=";
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
    (lib.cmakeBool "USE_WAYLAND_GRIM" enableWlrSupport)
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.qttools
    libsForQt5.qtsvg
    libsForQt5.wrapQtAppsHook
    makeBinaryWrapper
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.kguiaddons
  ];

  dontWrapQtApps = true;

  postFixup = ''
    wrapProgram $out/bin/flameshot \
      ${lib.optionalString enableWlrSupport "--prefix PATH : ${lib.makeBinPath [ grim ]}"} \
      ''${qtWrapperArgs[@]}
  '';

  meta = with lib; {
    description = "Powerful yet simple to use screenshot software";
    homepage = "https://github.com/flameshot-org/flameshot";
    mainProgram = "flameshot";
    maintainers = with maintainers; [ scode oxalica ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
