{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, cmake
, cppzmq
, doxygen
, ffmpeg
, imagemagick
, jsoncpp
, libopenshot-audio
, llvmPackages
, pkg-config
, python3
, qtbase
, qtmultimedia
, swig
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "libopenshot";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot";
    rev = "v${version}";
    sha256 = "sha256-axFGNq+Kg8atlaSlG8EKvxj/FwLfpDR8/e4otmnyosM=";
  };

  postPatch = ''
    sed -i 's/{UNITTEST++_INCLUDE_DIR}/ENV{UNITTEST++_INCLUDE_DIR}/g' tests/CMakeLists.txt
  '';

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ [
    cmake
    doxygen
    pkg-config
    swig
  ];

  buildInputs = [
    cppzmq
    ffmpeg
    imagemagick
    jsoncpp
    libopenshot-audio
    python3
    qtbase
    qtmultimedia
    zeromq
  ] ++ lib.optionals stdenv.isDarwin [
    llvmPackages.openmp
  ];

  dontWrapQtApps = true;

  doCheck = false;

  cmakeFlags = [
    "-DENABLE_RUBY=OFF"
    "-DPYTHON_MODULE_PATH=${python3.sitePackages}"
  ];

  meta = with lib; {
    homepage = "http://openshot.org/";
    description = "Free, open-source video editor library";
    longDescription = ''
      OpenShot Library (libopenshot) is an open-source project dedicated to
      delivering high quality video editing, animation, and playback solutions
      to the world. API currently supports C++, Python, and Ruby.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };

  passthru = {
    inherit libopenshot-audio;
  };
}
