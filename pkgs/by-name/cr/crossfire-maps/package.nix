{
  stdenv,
  lib,
  fetchgit,
}:

stdenv.mkDerivation {
  pname = "crossfire-maps";
  version = "2025-04";

  src = fetchgit {
    url = "https://git.code.sf.net/p/crossfire/crossfire-maps";
    rev = "ec57d473064ed1732adb1897415b56f96fbd9382";
    hash = "sha256-hJOMa8c80T4/NC37NKM270LDHNqWK6NZfKvKnFno9TE=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -a . "$out/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Map data for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    hydraPlatforms = [ ];
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
