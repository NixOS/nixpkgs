{stdenv, fetchurl, fetchFromGitHub, callPackage, cmake, doxygen
, imagemagick, ffmpeg, qt55, swig, python3, ruby, unittest-cpp
, cppzmq, czmqpp
}:

with stdenv.lib;

let
  libopenshot_audio = callPackage ./libopenshot-audio.nix {};
in
stdenv.mkDerivation rec {
  name = "libopenshot-${version}";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot";
    rev = "v${version}";
    sha256 = "00051ipb8y4z9j5m5smwm1ahv755k0glarwic8fv5b9fzryfbrdm";
  };

  patchPhase = ''
    sed -i 's/{UNITTEST++_INCLUDE_DIR}/ENV{UNITTEST++_INCLUDE_DIR}/g' tests/CMakeLists.txt
    sed -i 's/{_REL_PYTHON_MODULE_PATH}/ENV{_REL_PYTHON_MODULE_PATH}/g' src/bindings/python/CMakeLists.txt
    sed -i 's/{RUBY_VENDOR_ARCH_DIR}/ENV{RUBY_VENDOR_ARCH_DIR}/g' src/bindings/ruby/CMakeLists.txt
    export _REL_PYTHON_MODULE_PATH=$(toPythonPath $out)
    export RUBY_VENDOR_ARCH_DIR=$out/lib/ruby/site-packages
  '';

  buildInputs = [
    cmake doxygen
    imagemagick ffmpeg qt55.qtbase qt55.qtmultimedia swig python3 ruby
    unittest-cpp cppzmq czmqpp
  ];

  LIBOPENSHOT_AUDIO_DIR = "${libopenshot_audio}";
  "UNITTEST++_INCLUDE_DIR" = "${unittest-cpp}/include/UnitTest++";

  doCheck = false;

  meta = {
    homepage = "http://openshot.org/";
    description = "Free, open-source video editor";
    license = licenses.gpl3Plus;
    maintainers = [];
    platforms = platforms.linux;
  };
}
