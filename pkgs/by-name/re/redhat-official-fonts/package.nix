{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "redhat-official";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "RedHatOfficial";
    repo = "RedHatFont";
    rev = version;
    hash = "sha256-r43KtMIedNitb5Arg8fTGB3hrRZoA8oUHVEL24k4LeQ=";
  };

  installPhase = ''
    runHook preInstall

    for kind in mono proportional; do
      install -m444 -Dt $out/share/fonts/opentype fonts/$kind/static/otf/*.otf
      install -m444 -Dt $out/share/fonts/truetype fonts/$kind/static/ttf/*.ttf
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/RedHatOfficial/RedHatFont";
    description = "Red Hat's Open Source Fonts - Red Hat Display and Red Hat Text";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
