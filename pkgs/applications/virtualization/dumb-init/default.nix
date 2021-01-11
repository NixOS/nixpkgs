{ lib, stdenv, fetchFromGitHub, glibc }:

stdenv.mkDerivation rec {
  pname = "dumb-init";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0v6ggfjl3q5p4hf002ygs8rryyzrg0fqy836p403fq2fgm30k0xx";
  };

  buildInputs = [ glibc.static ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin dumb-init

    runHook postInstall
  '';

  meta = with lib; {
    description = "A minimal init system for Linux containers";
    homepage = "https://github.com/Yelp/dumb-init";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.linux;
  };
}
