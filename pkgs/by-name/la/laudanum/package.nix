{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "laudanum";
  version = "1.0-unstable-2017-12-15";

  src = fetchFromGitHub {
    owner = "junk13";
    repo = "laudanum";
    rev = "50e1c09d5f23b446c20ecec652c64f9622348364";
    hash = "sha256-Od/ciCQ5QM4b/u9nizHosj/zte2pdifO8IDZkrcmIeI=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/laudanum
    cp -a * $out/share/laudanum/
    runHook postInstall
  '';

  meta = {
    description = "Collection of injectable files, designed to be used in a pentest when SQL injection flaws are found and are in multiple languages for different environments";
    homepage = "https://github.com/junk13/laudanum";
    maintainers = with lib.maintainers; [ d3vil0p3r ];
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Plus;
  };
}
