{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libevent,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "fstrm";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "farsightsec";
    repo = "fstrm";
    rev = "v${version}";
    sha256 = "sha256-/WFP2g3Vuf/qaY8pprY8XFAlpEE+0SJUlFNWfa+7ZlE=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libevent
    openssl
  ];

  preBuild = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -L${openssl}/lib"
  '';

  doCheck = true;

  meta = with lib; {
    description = "Frame Streams implementation in C";
    homepage = "https://github.com/farsightsec/fstrm";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
