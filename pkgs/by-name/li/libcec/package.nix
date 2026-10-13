{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  pythonSupport ? false,
  python3,
  swig,
  udev,
  libcec_platform,
  withLibraspberrypi ? false,
  libraspberrypi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcec";
  version = "8.1.7";

  src = fetchFromGitHub {
    owner = "Pulse-Eight";
    repo = "libcec";
    rev = "libcec-${finalAttrs.version}";
    sha256 = "sha256-teh4w6pDn0HJ9W0FnqhnMYFBd6JxgK9QYfVqYHXviiI=";
  };

  # 1. Fix dlopen path
  # 2. Fix include directory for pkg-config: https://github.com/Pulse-Eight/libcec/pull/754
  postPatch = ''
    substituteInPlace include/cecloader.h --replace-fail "\"libcec." "\"$out/lib/libcec."
    substituteInPlace src/libcec/CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_PREFIX}/include" "\''${CMAKE_INSTALL_INCLUDEDIR}"
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
  ]
  ++ lib.optionals pythonSupport [
    swig
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    libcec_platform
  ]
  ++ lib.optional pythonSupport python3
  ++ lib.optional stdenv.hostPlatform.isLinux udev
  ++ lib.optional withLibraspberrypi libraspberrypi;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "-DHAVE_LINUX_API=1"
  ];

  # pyCecClient uses incorrect import path since:
  # https://github.com/Pulse-Eight/libcec/pull/655/changes
  #
  # Apparently the change was intended to fix ubuntu & windows
  # packages, so we manually revert it for our use case
  postFixup = lib.optionalString pythonSupport ''
    moveToOutput "lib/${python3.libPrefix}" "$python"
    moveToOutput "bin/pyCecClient" "$python_bin"
    substituteInPlace "$python_bin/bin/pyCecClient" \
      --replace-fail 'from cec import cec' 'import cec'
    wrapPythonProgramsIn "$python_bin" "$python"
  '';

  outputs = [
    "out"
    "bin"
    "dev"
  ]
  ++ lib.optionals pythonSupport [
    "python"
    "python_bin"
  ];

  meta = {
    description = "Allows you (with the right hardware) to control your device with your TV remote control using existing HDMI cabling";
    homepage = "http://libcec.pulse-eight.com";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    teams = [ lib.teams.kodi ];
  };
})
