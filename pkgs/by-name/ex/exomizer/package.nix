{
  lib,
  stdenv,
  fetchFromBitbucket,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exomizer";
  version = "3.1.2";

  src = fetchFromBitbucket {
    owner = "magli143";
    repo = "exomizer";
    rev = finalAttrs.version;
    hash = "sha256-HMgj6avGKssEUJIIecu+pebF40S9h/vKA39RWw4t6RA=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  installPhase = ''
    runHook preInstall
    install -D exomizer exobasic -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Compress archives that can still be unpacked by 8-bit systems";
    homepage = "https://bitbucket.org/magli143/exomizer/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "exomizer";
    platforms = lib.platforms.all;
  };
})
