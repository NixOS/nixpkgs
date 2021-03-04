{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, ninja, yasm
, libjpeg, openssl, libopus, ffmpeg, alsaLib, libpulseaudio, protobuf
, xorg, libXtst
}:

let
  rev = "a19877363082da634a3c851a4698376504d2eaee";
  sha256 = "03m6fkc3m2wbh821mr3ybsmd7sjllky44mizny96k4b249dkvzx7";

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
    xorg.libX11 libXtst
  ];

  cmakeFlags = [
    # Building as a shared library isn't officially supported and currently broken:
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  meta.license = lib.licenses.bsd3;
}
