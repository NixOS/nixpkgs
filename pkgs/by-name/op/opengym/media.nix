{
  lib,
  stdenvNoCC,
  src,
  version,
}:

stdenvNoCC.mkDerivation {
  pname = "opengym-media";
  inherit version src;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R catalogue/media/* $out/

    runHook postInstall
  '';

  meta = {
    description = "Exercise stills and animations for openGym (Gym Visual)";
    homepage = "https://github.com/DuarteSantos8/openGym";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ luuumine ];
    platforms = lib.platforms.all;
  };
}
