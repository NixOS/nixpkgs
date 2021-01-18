{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config,
  gettext, openssl
}:

with lib;

stdenv.mkDerivation {
  pname = "notbit";
  version = "2018-01-09";

  src = fetchFromGitHub {
    owner  = "bpeel";
    repo   = "notbit";
    rev    = "8b5d3d2da8ce54abae2536b4d97641d2c798cff3";
    sha256 = "1623n0lvx42mamvb2vwin5i38hh0nxpxzmkr5188ss2x7m20lmii";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ openssl gettext ];

  meta = {
    description = "A minimal Bitmessage client";
    homepage = "https://github.com/bpeel/notbit";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mog ];
    broken = true;
  };
}
