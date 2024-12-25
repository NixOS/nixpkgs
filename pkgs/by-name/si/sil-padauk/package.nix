{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "sil-padauk";
  version = "5.100";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/padauk/Padauk-${version}.zip";
    hash = "sha256-Y4ZcxbPcgF349wDuT352xqaJji+FMfBH6P7WSWOw2iI=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv *.ttf $out/share/fonts/truetype/
    mkdir -p $out/share/doc/${pname}-${version}
    mv *.txt documentation/ $out/share/doc/${pname}-${version}/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unicode-based font family with broad support for writing systems that use the Myanmar script";
    homepage = "https://software.sil.org/padauk";
    license = licenses.ofl;
    maintainers = with maintainers; [ serge ];
    platforms = platforms.all;
  };
}
