{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  sqlite,
  wxGTK32,
  libusb1,
  soapysdr,
  mesa_glu,
  libx11,
  gnuplot,
  fltk,
  withGui ? false,
}:

stdenv.mkDerivation rec {
  pname = "limesuite";
  version = "23.11.0";

  src = fetchFromGitHub {
    owner = "myriadrf";
    repo = "LimeSuite";
    rev = "v${version}";
    sha256 = "sha256-f1cXrkVCIc1MqTvlCUBFqzHLhIVueybVxipNZRlF2gE=";
  };

  patches = [
    # CMake < 3.5 fix. Remove upon next version bump
    (fetchpatch {
      url = "https://github.com/myriadrf/LimeSuite/commit/4e5ad459d50c922267a008e5cecb3efdbff31f09.patch";
      hash = "sha256-OASki3bISJvV7wjMz0pBT3kO5RvJ5BnymiF6ruHkCJ8=";
    })
    # Fixes for C23 (GCC 15). Remove upon next version bump
    (fetchpatch {
      url = "https://github.com/myriadrf/LimeSuite/commit/524cd2e548b11084e6f739b2dfe0f958c2e30354.patch";
      hash = "sha256-wxwhFjXcIgBMTJoJ6efdtyttxMFZviCTXtEb2qFX9yU=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ]
  ++ lib.optional (!withGui) "-DENABLE_GUI=OFF";

  buildInputs = [
    libusb1
    sqlite
    gnuplot
    libusb1
    soapysdr
  ]
  ++ lib.optionals withGui [
    fltk
    libx11
    mesa_glu
    wxGTK32
  ];

  doInstallCheck = true;

  postInstall = ''
    install -Dm444 -t $out/lib/udev/rules.d ../udev-rules/64-limesuite.rules
    install -Dm444 -t $out/share/limesuite bin/Release/lms7suite_mcu/*
  '';

  meta = {
    description = "Driver and GUI for LMS7002M-based SDR platforms";
    homepage = "https://github.com/myriadrf/LimeSuite";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.unix;
    badPlatforms = lib.optionals withGui lib.platforms.darwin; # withGui transitively depends on mesa, which is broken on darwin
  };
}
