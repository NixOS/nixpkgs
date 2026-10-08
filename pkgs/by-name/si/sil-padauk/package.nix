{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "sil-padauk";
  version = "6.000";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/padauk/Padauk-${version}.zip";
    hash = "sha256-zxhYMQ+Go00vETokHpPHIqrVLxuM0F8OKIXATtE3S2s=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv *.ttf $out/share/fonts/truetype/
    mkdir -p $out/share/doc/${pname}-${version}
    mv *.txt documentation/ $out/share/doc/${pname}-${version}/

    runHook postInstall
  '';

  meta = {
    description = "Unicode-based font family with broad support for writing systems that use the Myanmar script";
    homepage = "https://software.sil.org/padauk";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ serge ];
    platforms = lib.platforms.all;
  };
}
