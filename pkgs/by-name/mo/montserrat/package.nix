{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "montserrat";
  version = "9.000";

  src = fetchFromGitHub {
    owner = "JulietaUla";
    repo = "montserrat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fKgq3eUxrYBZtJuw2gs0K0wpW4BNqX5cDErF3IQ2ft4=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/

    mv fonts/otf $out/share/fonts/otf
    mv fonts/ttf $out/share/fonts/ttf
    mv fonts/webfonts $out/share/fonts/woff2

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
})
