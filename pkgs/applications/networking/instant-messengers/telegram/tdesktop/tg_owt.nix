{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, ninja, yasm
, libjpeg, openssl, libopus, ffmpeg, alsaLib, libpulseaudio, protobuf
}:

let
  rev = "be23804afce3bb2e80a1d57a7c1318c71b82b7de";
  sha256 = "0avdxkig8z1ainzyxkm9vmlvkyqbjalwb4h9s9kcail82mnldnhc";

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
    libjpeg openssl libopus ffmpeg alsaLib libpulseaudio protobuf
  ];

  cmakeFlags = [
    # Building as a shared library isn't officially supported and currently broken:
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  meta.license = lib.licenses.bsd3;
}
