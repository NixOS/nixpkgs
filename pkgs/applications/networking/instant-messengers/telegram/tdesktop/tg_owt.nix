{ lib, stdenv, fetchFromGitHub, cmake, ninja, yasm
, pkg-config, libjpeg, openssl, libopus, ffmpeg, alsaLib, libpulseaudio
}:

let
  rev = "1d4f7d74ff1a627db6e45682efd0e3b85738e426";
  sha256 = "1w03xmjn693ff489pg368jv21478vr4ldxyya4lsrx87fn88caj3";

in stdenv.mkDerivation {
  pname = "tg_owt";
  version = "git-${rev}";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    inherit rev sha256;
  };

  nativeBuildInputs = [ pkg-config cmake ninja yasm ];

  buildInputs = [ libjpeg openssl libopus ffmpeg alsaLib libpulseaudio ];

  meta.license = lib.licenses.bsd3;
}
