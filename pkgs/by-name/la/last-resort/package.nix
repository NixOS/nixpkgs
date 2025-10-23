{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "last-resort";
  version = "17.000";

  src = fetchurl {
    url = "https://github.com/unicode-org/last-resort-font/releases/download/${version}/LastResortHE-Regular.ttf";
    hash = "sha256-OpNv4jeenhZKj5gZCVy/U9kwWi0IUy2b5bSW9L5FvN4=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D -m 0644 $src $out/share/fonts/truetype/LastResortHE-Regular.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fallback font of last resort";
    homepage = "https://github.com/unicode-org/last-resort-font";
    license = licenses.ofl;
    maintainers = [ ];
  };
}
