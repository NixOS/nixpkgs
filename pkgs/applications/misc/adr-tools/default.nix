{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "adr-tools-${version}";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "npryce";
    repo = "adr-tools";
    rev = "${version}";
    sha256 = "19hs7fv8j1hw7gj0rr8vqfsxi1axkpg7rli0705nlcnxd9yc7rx6";
  };

  installPhase = ''
    mkdir -p "$out/bin"
    cp src/* "$out/bin"
  '';

  meta = {
    homepage = https://github.com/npryce/adr-tools;
    description = "Command-line tools for working with Architecture Decision Records";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.mbode ];
    platforms = stdenv.lib.platforms.unix;
  };
}
