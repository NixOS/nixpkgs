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
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot";
    rev = "v${version}";
    sha256 = "sha256-aF8wrPxFIjCy5gw72e/WyL/Wcx9tUGDkrqHS+ZDVK0U=";
  };

  postPatch = ''
    sed -i 's/{UNITTEST++_INCLUDE_DIR}/ENV{UNITTEST++_INCLUDE_DIR}/g' tests/CMakeLists.txt
    sed -i 's/{_REL_PYTHON_MODULE_PATH}/ENV{_REL_PYTHON_MODULE_PATH}/g' bindings/python/CMakeLists.txt
    export _REL_PYTHON_MODULE_PATH=$(toPythonPath $out)
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

  cmakeFlags = [ "-DENABLE_RUBY=OFF" ];

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
