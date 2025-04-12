{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  majorVersion = "0";
  minorVersion = "100";
in
stdenvNoCC.mkDerivation {
  pname = "penna";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/penna_${majorVersion}${minorVersion}.zip";
    hash = "sha256-fmCJnEaoUGdW9JK3J7JSm5D4qOMRW7qVKPgVE7uCH5w=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/penna/";
    description = "Geometric sans serif designed by Sora Sagano";
    longDescription = ''
      Penna is a geometric sans serif designed by Sora Sagano,
      with outsized counters in the uppercase and a lowercase
      with a small x-height.
    '';
    platforms = platforms.all;
    maintainers = with maintainers; [
      leenaars
      minijackson
    ];
    license = licenses.cc0;
  };
}
