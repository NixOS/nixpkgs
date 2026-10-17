{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "samblaster";
  version = "0.1.26";

  src = fetchFromGitHub {
    owner = "GregoryFaust";
    repo = "samblaster";
    rev = "v.${finalAttrs.version}";
    hash = "sha256-Wwb6KgUkrnu4N/WwBC3vlY/+6HgX9wEnfs7SCwt2RDw=";
  };

  makeFlags = [ "CPP=${stdenv.cc.targetPrefix}c++" ];

  installPhase = ''
    mkdir -p $out/bin
    cp samblaster $out/bin
  '';

  meta = {
    description = "Tool for marking duplicates and extracting discordant/split reads from SAM/BAM files";
    mainProgram = "samblaster";
    maintainers = with lib.maintainers; [ jbedo ];
    license = lib.licenses.mit;
    homepage = "https://github.com/GregoryFaust/samblaster";
    platforms = lib.platforms.x86_64;
  };
})
