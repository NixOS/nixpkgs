{
  lib,
  stdenv,
  fetchzip,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "braa";
  version = "0.82";

  src = fetchzip {
    url = "http://s-tech.elsat.net.pl/braa/braa-${finalAttrs.version}.tar.gz";
    hash = "sha256-GS3kk432BdGx/sLzzjXvotD9Qn4S3U4XtMmM0fWMhGA=";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    runHook preInstall
    install -Dm755 braa $out/bin/braa
    runHook postInstall
  '';

  meta = {
    description = "Mass snmp scanner";
    homepage = "http://s-tech.elsat.net.pl";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bycEEE ];
    mainProgram = "braa";
  };
})
