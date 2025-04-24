{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dnsmap";
  tag = "0.36";
  version = "${finalAttrs.tag}-unstable-2024-08-20";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = "dnsmap";
    rev = "b5b4b1a7764e141f2551584d9fad3a973951eafe";
    hash = "sha256-RTZe0kb/Fq9kIdnHQO//OP+Uop2Z5r22Z7+rQdCFsl4=";
  };

  strictDeps = true;

  preConfigure = ''
    autoreconf -i
  '';

  configureFlags = [ "--prefix=$(out)" ];

  nativeBuildInputs = [
    autoconf
    automake
  ];

  meta = {
    description = "Scan for subdomains using brute-force techniques";
    homepage = "https://github.com/resurrecting-open-source-projects/dnsmap";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ heywoodlh ];
    changelog = "https://github.com/resurrecting-open-source-projects/dnsmap/releases/tag/${finalAttrs.tag}";
    mainProgram = "dnsmap";
  };
})
