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
  imgroot = "https://build.anbox.io/android-images";
  android_image = {
    "armv7l-linux" = {
      url = "${imgroot}/2017/06/12/android_1_armhf.img";
      sha256 = "1za4q6vnj8wgphcqpvyq1r8jg6khz7v6b7h6ws1qkd5ljangf1w5";
    };
    "aarch64-linux" = {
      url = "${imgroot}/2017/08/04/android_1_arm64.img";
      sha256 = "02yvgpx7n0w0ya64y5c7bdxilaiqj9z3s682l5s54vzfnm5a2bg5";
    };
    "x86_64-linux" = {
      url = "${imgroot}/2017/07/13/android_3_amd64.img";
      sha256 = "1l22pisan3kfq4hwpizxc24f8lr3m5hd6k69nax10rki9ljypji0";
    };
  }.${stdenv.system};
  imgDrv = stdenv.mkDerivation {
    name = "anbox-image-${stdenv.system}-${version}";
    src = fetchurl {
      inherit (android_image) url sha256;
    };
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
    imgDrv
    boost dbus dbus.lib dbus-cpp glib glm gmock gtest
    libcap libdrm libproperties-cpp libpthreadstubs libXdamage libXdmcp lxc
    mesa protobuf protobufc
    python2
    SDL2 SDL2_image
  ];

  # see https://github.com/volth/nixpkgs/blob/5591b05bd5986ad94df34973841558a64c78fe98/pkgs/applications/virtualization/anbox/default.nix#L21
  # regarding gmock
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
