{
  stdenv,
  lib,
  overrideSDK,
  darwin,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  imagemagick,
  libicns,
  libsForQt5,
  grim,
  makeBinaryWrapper,
  nix-update-script,
  enableWlrSupport ? false,
  enableMonochromeIcon ? false,
}:

assert stdenv.isDarwin -> (!enableWlrSupport);

let
  stdenv' = if stdenv.isDarwin then overrideSDK stdenv "11.0" else stdenv;
in

stdenv'.mkDerivation {
  pname = "flameshot";
  # wlr screenshotting is currently only available on unstable version (>12.1.0)
  version = "12.1.0-unstable-2024-09-01";

  src = fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "14a136777cd82ab70f42c13b4bc9418c756d91d2";
    hash = "sha256-xM99adstwfOOaeecKyWQU3yY0p65pQyFgoz7WJNra98=";
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

  cmakeFlags =
    [
      (lib.cmakeBool "DISABLE_UPDATE_CHECKER" true)
      (lib.cmakeBool "USE_MONOCHROME_ICON" enableMonochromeIcon)
    ]
    ++ lib.optionals stdenv.isLinux [
      (lib.cmakeBool "USE_WAYLAND_CLIPBOARD" true)
      (lib.cmakeBool "USE_WAYLAND_GRIM" enableWlrSupport)
    ]
    ++ lib.optionals stdenv.isDarwin [
      (lib.cmakeFeature "Qt5_DIR" "${libsForQt5.qtbase.dev}/lib/cmake/Qt5")
    ];

  nativeBuildInputs =
    [
      cmake
      libsForQt5.qttools
      libsForQt5.qtsvg
      libsForQt5.wrapQtAppsHook
      makeBinaryWrapper
    ]
    ++ lib.optionals stdenv.isDarwin [
      imagemagick
      libicns
    ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.kguiaddons
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Fix icns generation running concurrently with png generation
    sed -E -i '/"iconutil -o/i\
        )\
        execute_process(\
    ' src/CMakeLists.txt

    # Replace unavailable commands
    sed -E -i \
        -e 's/"sips -z ([0-9]+) ([0-9]+) +(.+) --out /"magick \3 -resize \1x\2\! /' \
        -e 's/"iconutil -o (.+) -c icns (.+)"/"png2icns \1 \2\/*{16,32,128,256,512}.png"/' \
        src/CMakeLists.txt
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/flameshot.app $out/Applications

    ln -s $out/Applications/flameshot.app/Contents/MacOS/flameshot $out/bin/flameshot

    rm -r $out/share/applications
    rm -r $out/share/dbus*
    rm -r $out/share/icons
    rm -r $out/share/metainfo
  '';

  dontWrapQtApps = true;

  postFixup =
    let
      binary =
        if stdenv.isDarwin then "Applications/flameshot.app/Contents/MacOS/flameshot" else "bin/flameshot";
    in
    ''
      wrapProgram $out/${binary} \
        ${lib.optionalString enableWlrSupport "--prefix PATH : ${lib.makeBinPath [ grim ]}"} \
        ''${qtWrapperArgs[@]}
    '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = with lib; {
    description = "Powerful yet simple to use screenshot software";
    homepage = "https://github.com/flameshot-org/flameshot";
    mainProgram = "flameshot";
    maintainers = with maintainers; [
      scode
      oxalica
    ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
