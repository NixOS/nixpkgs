{
  lib,
  stdenv,
  fetchFromGitHub,
  libevent,
}:

stdenv.mkDerivation rec {
  pname = "redsocks";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "darkk";
    repo = "redsocks";
    rev = "release-${version}";
    sha256 = "170cpvvivb6y2kwsqj9ppx5brgds9gkn8mixrnvj8z9c15xhvplm";
  };

  installPhase = ''
    mkdir -p $out/{bin,share}
    mv redsocks $out/bin
    mv doc $out/share
  '';

  buildInputs = [ libevent ];

  meta = {
    description = "Transparent redirector of any TCP connection to proxy";
    homepage = "https://darkk.net.ru/redsocks/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ekleog ];
    platforms = lib.platforms.linux;
    mainProgram = "redsocks";
  };
}
