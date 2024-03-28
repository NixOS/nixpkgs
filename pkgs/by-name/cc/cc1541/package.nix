{ lib
, stdenv
, fetchFromBitbucket
, asciidoc
}:

stdenv.mkDerivation rec {
  pname = "cc1541";
  version = "4.1";

  src = fetchFromBitbucket {
    owner = "ptv_claus";
    repo = "cc1541";
    rev = version;
    hash = "sha256-b8cEGC3WxrjebQjed/VD9SIWkiQpNaE2yW+bQRCtmSs=";
  };

  ENABLE_MAN = 1;

  makeFlags = [ "prefix=$(out)" ];

  nativeBuildInputs = [ asciidoc ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preCheck
    make test
    runHook postCheck
  '';

  meta = with lib; {
    description = "tool for creating Commodore 1541 Floppy disk images in D64, D71 or D81 format";
    homepage = "https://bitbucket.org/ptv_claus/cc1541/src/master/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "cc1541";
    platforms = platforms.all;
  };
}
