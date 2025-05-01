{
  stdenv,
  lib,
  fetchgit,
}:

stdenv.mkDerivation {
  pname = "crossfire-arch";
  version = "2025-04";

  src = fetchgit {
    url = "https://git.code.sf.net/p/crossfire/crossfire-arch";
    rev = "876eb50b9199e9aa06175b7a7d85832662be3f78";
    hash = "sha256-jDiAKcjWYvjGiD68LuKlZS4sOR9jW3THp99kAEdE+y0=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -a . "$out/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Archetype data for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    hydraPlatforms = [ ];
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
