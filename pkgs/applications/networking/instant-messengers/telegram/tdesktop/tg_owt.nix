{ lib, stdenv, fetchFromGitHub, cmake, ninja, yasm
, pkg-config, libjpeg, openssl, libopus, ffmpeg, alsaLib, libpulseaudio
}:

let
  rev = "e8fcae73947445db3d418fb7c20b964b59e14706";
  sha256 = "0s2dd41r71aixhvympiqfks1liv7x78y60n0i87vmyxyfx449b5h";

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
