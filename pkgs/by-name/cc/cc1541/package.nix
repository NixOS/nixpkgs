{
  lib,
  stdenv,
  fetchFromBitbucket,
  asciidoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cc1541";
  version = "unstable-2024-02-29";

  src = fetchFromBitbucket {
    owner = "ptv_claus";
    repo = "cc1541";
    rev = "f51ba77";
    hash = "sha256-IKkQhm6oBpv6VZNLxt1SMVZ6Xm8AGNjxLfHYS2OvT8A=";
  };

  env.ENABLE_MAN = 1;

  makeFlags = [ "prefix=$(out)" ];

  nativeBuildInputs = [ asciidoc ];

  doInstallCheck = true;

  installCheckPhase = ''
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
