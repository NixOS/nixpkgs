{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, ninja, yasm
, libjpeg, openssl, libopus, ffmpeg, alsaLib, libpulseaudio, protobuf
}:

let
  rev = "6eaebec41b34a0a0d98f02892d0cfe6bbcbc0a39";
  sha256 = "0dbc36j09jmxvznal55hi3qrfyvj4y0ila6347nav9skcmk8fm64";

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

  meta.license = lib.licenses.bsd3;
}
