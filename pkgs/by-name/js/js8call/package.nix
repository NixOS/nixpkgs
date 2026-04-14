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
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "JS8Call-improved";
    repo = "JS8Call-improved";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-dpPh3+s29ksdVGc1I5JOJrqzS51Bda8afgU5RrO6B3w=";
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

  # The "install" target is apparently no longer supported so we have
  # to copy the built assets explicitly.
  # https://github.com/JS8Call-improved/JS8Call-improved/issues/115
  installPhase = ''
    mkdir -p $out/bin $out/share/doc/js8call $out/share/icons/hicolor/128x128/apps $out/share/applications
    cp JS8Call $out/bin/js8call
    cp ../LICENSE ../README.md $out/share/doc/js8call
    cp ../artwork/js8call_icon.png $out/share/icons/hicolor/128x128/apps
    cp ../JS8Call.desktop $out/share/applications
    runHook postInstall
  '';

  # We renamed the executable to lowercase for consistency with older
  # versions and Linux more generally. Fix up the desktop file here:
  postInstall = ''
    substituteInPlace $out/share/applications/JS8Call.desktop \
      --replace-fail "Exec=JS8Call" "Exec=js8call"
  '';

  meta = {
    description = "Weak-signal keyboard messaging for amateur radio";
    longDescription = ''
      JS8Call is software using the JS8 Digital Mode providing weak signal
      keyboard to keyboard messaging to Amateur Radio Operators.

      JS8Call-Improved is a community-driven evolution of JS8Call,
      bringing modern features, active development, and long-term
      support to HF digital communication. It’s fully compatible with
      existing JS8Call versions while adding new capabilities and
      refinements.
    '';
    homepage = "https://js8call-improved.com/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      sarcasticadmin
      pdg137
    ];
  };
})
