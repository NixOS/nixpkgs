{
  lib,
  stdenv,
  fetchFromSourcehut,
  cmake,
  kdePackages,
  libusb1,
  pkg-config,
  zlib,
  enableGUI ? false,
}:

stdenv.mkDerivation rec {
  pname = "heimdall${lib.optionalString enableGUI "-gui"}";
  version = "2.2.1";

  src = fetchFromSourcehut {
    owner = "~grimler";
    repo = "Heimdall";
    rev = "v${version}";
    hash = "sha256-x+mDTT+oUJ4ffZOmn+UDk3+YE5IevXM8jSxLKhGxXSM=";
  };

  buildInputs =
    [
      libusb1
      zlib
    ]
    ++ lib.lists.optionals enableGUI [
      kdePackages.qtbase
    ];
  nativeBuildInputs =
    [
      cmake
      pkg-config
    ]
    ++ lib.lists.optionals enableGUI [
      kdePackages.wrapQtAppsHook
    ];

  cmakeFlags = [
    (lib.cmakeBool "DISABLE_FRONTEND" (!enableGUI))
    (lib.cmakeFeature "LIBUSB_LIBRARY" "${libusb1}")
  ];

  installPhase =
    lib.optionalString (stdenv.hostPlatform.isDarwin && enableGUI) ''
      mkdir -p $out/Applications
      mv bin/heimdall-frontend.app $out/Applications/heimdall-frontend.app
      wrapQtApp $out/Applications/heimdall-frontend.app/Contents/MacOS/heimdall-frontend
    ''
    + ''
      mkdir -p $out/{bin,share/doc/heimdall,lib/udev/rules.d}
      install -m755 -t $out/bin                bin/*
      install -m644 -t $out/lib/udev/rules.d   ../heimdall/60-heimdall.rules
      install -m644 ../README.md               $out/share/doc/heimdall/README.md
      install -m644 ../doc/*                   $out/share/doc/heimdall/
    '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~grimler/Heimdall";
    description = "Cross-platform tool suite to flash firmware onto Samsung Galaxy devices";
    license = licenses.mit;
    maintainers = with maintainers; [
      timschumi
    ];
    platforms = platforms.unix;
    mainProgram = "heimdall${lib.optionalString enableGUI "-frontend"}";
  };
}
