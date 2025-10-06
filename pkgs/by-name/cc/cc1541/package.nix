{
  lib,
  stdenv,
  fetchFromBitbucket,
  asciidoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cc1541";
  version = "4.2";

  src = fetchFromBitbucket {
    owner = "ptv_claus";
    repo = "cc1541";
    rev = finalAttrs.version;
    hash = "sha256-+9ri3fUmxLHXxq9vNMjeNXfHula3PZpjewHO6z7pIhc=";
  };

  # Manual generation broke in 4.2
  env.ENABLE_MAN = false;

  makeFlags = [ "prefix=$(out)" ];

  nativeBuildInputs = [ asciidoc ];

  doInstallCheck = true;

  checkPhase = ''
    runHook preCheck

    make test

    runHook postCheck
  '';

  meta = with lib; {
    description = "Tool for creating Commodore 1541 Floppy disk images in D64, D71 or D81 format";
    homepage = "https://bitbucket.org/ptv_claus/cc1541/src/master/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "cc1541";
    platforms = platforms.all;
  };
})
