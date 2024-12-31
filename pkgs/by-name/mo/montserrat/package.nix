{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "montserrat";
  version = "7.222";

  src = fetchFromGitHub {
    owner = "JulietaUla";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eVCRn2OtNI5NuYZBQy06HKnMMXhPPnFxI8m8kguZjg0=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/{otf,ttf,woff,woff2}

    mv fonts/otf/*.otf $out/share/fonts/otf
    mv fonts/ttf/*.ttf $out/share/fonts/ttf
    mv fonts/webfonts/*.woff $out/share/fonts/woff
    mv fonts/webfonts/*.woff2 $out/share/fonts/woff2

    runHook postInstall
  '';

  meta = with lib; {
    description = "Geometric sans serif font with extended latin support (Regular, Alternates, Subrayada)";
    homepage = "https://www.fontspace.com/julieta-ulanovsky/montserrat";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [
      scolobb
      jk
    ];
  };
}
