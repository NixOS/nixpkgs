{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "brygada-1918";
  version = "3.006";

  src = fetchFromGitHub {
    owner = "kosmynkab";
    repo = "Brygada-1918";
    rev = "8325dc36ca87b8c7b8909c3e048fe90fd7e46c4b";
    hash = "sha256-ePehnBYFlm+iExf2Sy25PsIWvtHlys2hcCZ4cHT+H1k=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/opentype fonts/otf/*.otf
    install -Dm444 -t $out/share/fonts/truetype fonts/ttf/*.ttf
    install -Dm444 -t $out/share/fonts/variable fonts/variable/*.ttf

    runHook postInstall
  '';

  meta = {
    description = "Digital revival of the Brygada serif typeface";
    homepage = "https://brygada1918.eu/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ oidro ];
  };
}
