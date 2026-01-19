{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "besley";
  version = "4.0-unstable-2023-01-09";

  src = fetchFromGitHub {
    owner = "indestructible-type";
    repo = "Besley";
    rev = "99d5b97fcb863c4a667571ac8f86f745c345d3ab";
    hash = "sha256-N6QU3Pd6EnIrdbRtDT3mW5ny683DBWo0odADJBSdA2E=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp fonts/*/*.otf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    homepage = "https://indestructibletype.com/Besley.html";
    description = "Besley an antique slab serif font by indestructible type*";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ gavink97 ];
  };
}
