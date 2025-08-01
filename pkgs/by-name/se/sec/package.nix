{
  fetchFromGitHub,
  perl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "sec";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "simple-evcorr";
    repo = "sec";
    rev = version;
    sha256 = "sha256-iK2v/qCWw4jdSEpx6cwSB98n5iFmbCyJH0lIpUG8pAU=";
  };

  buildInputs = [ perl ];

  dontBuild = false;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp sec $out/bin
    cp sec.man $out/share/man/man1/sec.1
  '';

  meta = {
    homepage = "https://simple-evcorr.github.io";
    license = lib.licenses.gpl2Plus;
    description = "Simple Event Correlator";
    maintainers = [ lib.maintainers.tv ];
    platforms = lib.platforms.all;
    mainProgram = "sec";
  };
}
