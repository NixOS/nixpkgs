{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libevent,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fstrm";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "farsightsec";
    repo = "fstrm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/WFP2g3Vuf/qaY8pprY8XFAlpEE+0SJUlFNWfa+7ZlE=";
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

  strictDeps = true;

  preBuild = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -L${openssl}/lib"
  '';

  doCheck = true;

  __structuredAttrs = true;

  meta = {
    description = "Frame Streams implementation in C";
    homepage = "https://github.com/farsightsec/fstrm";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
