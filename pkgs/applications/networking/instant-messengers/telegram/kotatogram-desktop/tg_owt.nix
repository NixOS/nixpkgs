{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, ninja, yasm
, libjpeg, openssl, libopus, ffmpeg_4, alsa-lib, libpulseaudio, protobuf
, xorg, libXtst
}:

let
  rev = "2d804d2c9c5d05324c8ab22f2e6ff8306521b3c3";
  sha256 = "0kz0i381iwsgcc3yzsq7njx3gkqja4bb9fsgc24vhg0md540qhyn";

in stdenv.mkDerivation {
  pname = "tg_owt";
  version = "git-${rev}";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    inherit rev sha256;
    fetchSubmodules = true;
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config cmake ninja yasm ];

  buildInputs = [
    libjpeg openssl libopus ffmpeg_4 alsa-lib libpulseaudio protobuf
    xorg.libX11 libXtst
  ];

  cmakeFlags = [
    # Building as a shared library isn't officially supported and currently broken:
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  meta.license = lib.licenses.bsd3;
}
