{
  lib,
  fetchzip,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "minecraftia";
  version = "1.0";

  src = fetchzip {
    url = "https://fontlibrary.org/assets/downloads/minecraftia/71962a7e3d4a70435c030466a12f1d63/minecraftia.zip";
    hash = "sha256-AZFSts0GpBttbhl1LHMORiqqc9o7ZWhh5hbjhSnxAlA=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype $src/Minecraftia.ttf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://fontlibrary.org/en/font/minecraftia";
    description = "Cool Minecraft font";
    license = licenses.cc-by-sa-30;
    platforms = platforms.all;
    maintainers = with lib.maintainers; [ gepbird ];
  };
}
