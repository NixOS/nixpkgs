{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "libre-baskerville";
  version = "1.000";

  src = fetchFromGitHub {
    owner = "impallari";
    repo = "Libre-Baskerville";
    rev = "2fba7c8e0a8f53f86efd3d81bc4c63674b0c613f";
    hash = "sha256-1EXi1hxFpc7pFsLbEj1xs9LqjeIf3XBol/8HdKNROUU=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype *.ttf
    install -m444 -Dt $out/share/doc/${pname}-${version} README.md FONTLOG.txt

    runHook postInstall
  '';

  meta = with lib; {
    description = "Webfont family optimized for body text";
    longDescription = ''
      Libre Baskerville is a webfont family optimized for body text. It's Based
      on 1941 ATF Baskerville Specimens but it has a taller x-height, wider
      counters and less contrast that allow it to work on small sizes in any
      screen.
    '';
    homepage = "http://www.impallari.com/projects/overview/libre-baskerville";
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
