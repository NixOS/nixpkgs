{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  hamlib_4,
  libusb1,
  cmake,
  fftw,
  fftwFloat,
  qt6,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "js8call";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "js8call";
    repo = "js8call";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-rYXjcmQRRfizJVriZo9yX8x2yYfWpL94Cprx9eFC3ss=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    pkg-config
    cmake
  ];

  buildInputs = [
    hamlib_4
    libusb1
    fftw
    fftwFloat
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtserialport
    boost
  ];

  prePatch = ''
    substituteInPlace CMakeLists.txt \
        --replace "/usr/share/applications" "$out/share/applications" \
        --replace "/usr/share/pixmaps" "$out/share/pixmaps" \
        --replace "/usr/bin/" "$out/bin"
  '';

  meta = with lib; {
    description = "Weak-signal keyboard messaging for amateur radio";
    longDescription = ''
      JS8Call is software using the JS8 Digital Mode providing weak signal
      keyboard to keyboard messaging to Amateur Radio Operators.
    '';
    homepage = "http://js8call.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      melling
      sarcasticadmin
    ];
  };
})
