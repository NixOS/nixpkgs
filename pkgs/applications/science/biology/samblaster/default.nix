{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "samblaster";
  version = "0.1.26";

  src = fetchFromGitHub {
    owner = "GregoryFaust";
    repo = "samblaster";
    rev = "v.${version}";
    sha256 = "0g24fq5hplnfgqkh3xqpg3lgx3wmxwnh9c7m6yw7pbi40lmgl1jv";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp samblaster $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Tool for marking duplicates and extracting discordant/split reads from SAM/BAM files";
    maintainers = with maintainers; [ jbedo ];
    license = licenses.mit;
    homepage = "https://github.com/GregoryFaust/samblaster";
    platforms = platforms.x86_64;
  };
}
