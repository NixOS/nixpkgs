{ lib, stdenv, fetchFromGitHub, cmake, ninja, yasm
, pkg-config, libjpeg, openssl, libopus, ffmpeg, alsaLib, libpulseaudio
}:

let
  rev = "c73a4718cbff7048373a63db32068482e5fd11ef";
  sha256 = "0nr20mvvmmg8ii8f2rljd7iv2szplcfjn40rpy6llkmf705mwr1k";

in stdenv.mkDerivation {
  pname = "tg_owt";
  version = "git-${rev}";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    inherit rev sha256;
  };

  patches = [ ./tg_owt-install.patch ];

  nativeBuildInputs = [ pkg-config cmake ninja yasm ];

  buildInputs = [ libjpeg openssl libopus ffmpeg alsaLib libpulseaudio ];

  meta.license = lib.licenses.bsd3;
}
