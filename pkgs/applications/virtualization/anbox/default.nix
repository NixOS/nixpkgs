{ stdenv, lib, fetchFromGitHub, fetchurl
, cmake
, pkgconfig

### Discovered
, libdrm
, libpthreadstubs
, libXdmcp
, libXdamage
, SDL2_image
, python2
, libproperties-cpp
, glm
### From README
, dbus
, gmock
, gtest
, boost
, libcap
, dbus-cpp
, mesa
, glib
, SDL2
, protobuf
, protobufc
, lxc

}:
let
    images = {
        "armv7l-linux" = "https://build.anbox.io/android-images/2017/06/12/android_1_armhf.img";
        "aarch64-linux" = "https://build.anbox.io/android-images/2017/08/04/android_1_arm64.img";
        "x86_64-linux" = "https://build.anbox.io/android-images/2017/07/13/android_3_amd64.img";
    };
    version = "2018-01-06";
in
stdenv.mkDerivation {
  name = "anbox-${version}";

  src = fetchFromGitHub {
    owner = "anbox";
    repo = "anbox";
    rev = "da3319106e6f568680017592aecdee34f0e407ac";
    sha256 = "0mgc6gp1km12qnshvsr26zn8bdd9gdix2s9xab594vq06ckznysd";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
    boost dbus dbus.lib dbus-cpp glib glm gmock gtest
    libcap libdrm libproperties-cpp libpthreadstubs libXdamage libXdmcp lxc
    mesa protobuf protobufc
    python2
    SDL2 SDL2_image
  ];

  patchPhase = ''
    sed -i '/GMock/d' CMakeLists.txt

    sed -i '1c#!python' scripts/gen-emugl-entries.py
    sed -i 's/native()/native_handle()/g' src/anbox/network/base_socket_messenger.cpp

    sed -i '/tests/d' CMakeLists.txt
    patchShebangs scripts
    # source/src/anbox/runtime.cpp:56:16:
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-narrowing"
  '';

  meta = {
    description = "Android containerization layer";
    homepage = "https://anbox.io/";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ lukeadams ];
    platforms = lib.platforms.linux;
  };
}
