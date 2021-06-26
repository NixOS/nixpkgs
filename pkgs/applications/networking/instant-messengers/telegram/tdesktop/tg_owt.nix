{ lib, stdenv, fetchFromGitHub, fetchpatch
, pkg-config, cmake, ninja, yasm
, libjpeg, openssl, libopus, ffmpeg, alsaLib, libpulseaudio, protobuf
, xorg, libXtst, libXcomposite, libXdamage, libXext, libXrender, libXrandr
, glib, abseil-cpp, pcre, util-linuxMinimal, libselinux, libsepol, pipewire
}:

stdenv.mkDerivation {
  pname = "tg_owt";
  version = "unstable-2021-06-17";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    rev = "f03ef05abf665437649a4f71886db1343590e862";
    sha256 = "0s6ajw52b95lcq4mn6lv8gj6lhv62bvwjh43w7az2k5pbm14v7vv";
    fetchSubmodules = true;
  };

  patches = [
    # Our libXtst seems broken:
    # /nix/store/rd3swxwmzjgjvwhz8svyc8ghc0brq293-libXtst-1.2.3/include/X11/extensions/XTest.h:32:10: fatal error: X11/extensions/XInput.h: No such file or directory
    (fetchpatch {
      # Copy updated source files.
      url = "https://github.com/desktop-app/tg_owt/commit/2c0fbe4d3d1c33d0cc9ff7c112b4db1963bea535.patch";
      sha256 = "0apd6hfv3a1s3qy10kjwk4z8bg835cpk0ql9qxjnxf4gq183bhif";
      revert = true;
      includes = [ "src/modules/desktop_capture/linux/shared_x_display.cc" ];
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config cmake ninja yasm ];

  buildInputs = [
    libjpeg openssl libopus ffmpeg alsaLib libpulseaudio protobuf
    xorg.libX11 libXtst libXcomposite libXdamage libXext libXrender libXrandr
    glib abseil-cpp pcre util-linuxMinimal libselinux libsepol pipewire
  ];

  cmakeFlags = [
    # Building as a shared library isn't officially supported and currently broken:
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  meta.license = lib.licenses.bsd3;
}
