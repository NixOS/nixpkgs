{ lib, stdenv, fetchFromGitHub, autoconf, automake }:

stdenv.mkDerivation (finalAttrs: {
  pname = "dnsmap";
  version = "0.36-unstable-2024-06-16";

  src = fetchFromGitHub rec {
    owner = "resurrecting-open-source-projects";
    repo = "dnsmap";
    rev = "b5b4b1a7764e141f2551584d9fad3a973951eafe";
    hash = "sha256-RTZe0kb/Fq9kIdnHQO//OP+Uop2Z5r22Z7+rQdCFsl4=";
  };

  buildInputs = [
    autoconf
    automake
  ];

  preConfigure = ''
    autoreconf -i
  '';

  configureFlags = [ "--prefix=$(out)" ];

  meta = {
    description = "Scan for subdomains using bruteforcing techniques ";
    homepage = "https://github.com/resurrecting-open-source-projects/dnsmap";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      heywoodlh
    ];
    mainProgram = "dnsmap";
  };
})
