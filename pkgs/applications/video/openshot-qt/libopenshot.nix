{ stdenv, fetchFromGitHub, fetchpatch
, pkgconfig, cmake, doxygen
, libopenshot-audio, imagemagick, ffmpeg_3
, swig, python3
, unittest-cpp, cppzmq, zeromq
, qtbase, qtmultimedia
, llvmPackages
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "libopenshot";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot";
    rev = "v${version}";
    sha256 = "1mxjkgjmjzgf628y3rscc6rqf55hxgjpmvwxlncfk1216i5xskwp";
  };

  patches = [
    (fetchpatch {
      name = "fix-build-with-gcc-10.patch";
      url = "https://github.com/OpenShot/libopenshot/commit/13290364e7bea54164ab83d973951f2898ad9e23.diff";
      sha256 = "0i7rpdsr8y9dphil8yq75qbh20vfqjc2hp5ahv0ws58z9wj6ngnz";
    })
  ];

  postPatch = ''
    sed -i 's/{UNITTEST++_INCLUDE_DIR}/ENV{UNITTEST++_INCLUDE_DIR}/g' tests/CMakeLists.txt
    sed -i 's/{_REL_PYTHON_MODULE_PATH}/ENV{_REL_PYTHON_MODULE_PATH}/g' src/bindings/python/CMakeLists.txt
    export _REL_PYTHON_MODULE_PATH=$(toPythonPath $out)
  '';

  nativeBuildInputs = [ pkgconfig cmake doxygen ];

  buildInputs =
  [ imagemagick ffmpeg_3 swig python3 unittest-cpp
    cppzmq zeromq qtbase qtmultimedia ]
    ++ optional stdenv.isDarwin llvmPackages.openmp
  ;

  LIBOPENSHOT_AUDIO_DIR = libopenshot-audio;
  "UNITTEST++_INCLUDE_DIR" = "${unittest-cpp}/include/UnitTest++";

  doCheck = false;

  cmakeFlags = [ "-DENABLE_RUBY=OFF" ];

  meta = {
    homepage = "http://openshot.org/";
    description = "Free, open-source video editor library";
    longDescription = ''
      OpenShot Library (libopenshot) is an open-source project dedicated to
      delivering high quality video editing, animation, and playback solutions
      to the world. API currently supports C++, Python, and Ruby.
    '';
    license = with licenses; gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
