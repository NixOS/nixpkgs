{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "samblaster";
  version = "0.1.26";

  src = fetchFromGitHub {
    owner = "GregoryFaust";
    repo = "samblaster";
    rev = "v.${version}";
    sha256 = "0g24fq5hplnfgqkh3xqpg3lgx3wmxwnh9c7m6yw7pbi40lmgl1jv";
  };

  makeFlags = [ "CPP=${stdenv.cc.targetPrefix}c++" ];

  installPhase = ''
    mkdir -p $out/bin
    cp samblaster $out/bin
  '';

<<<<<<< HEAD
  meta = {
    description = "Tool for marking duplicates and extracting discordant/split reads from SAM/BAM files";
    mainProgram = "samblaster";
    maintainers = with lib.maintainers; [ jbedo ];
    license = lib.licenses.mit;
    homepage = "https://github.com/GregoryFaust/samblaster";
    platforms = lib.platforms.x86_64;
=======
  meta = with lib; {
    description = "Tool for marking duplicates and extracting discordant/split reads from SAM/BAM files";
    mainProgram = "samblaster";
    maintainers = with maintainers; [ jbedo ];
    license = licenses.mit;
    homepage = "https://github.com/GregoryFaust/samblaster";
    platforms = platforms.x86_64;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
