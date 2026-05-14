{
  lib,
  fetchzip,
  stdenvNoCC,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "minecraftia";
  version = "1.0";

  src = fetchzip {
    url = "https://fontlibrary.org/assets/downloads/minecraftia/71962a7e3d4a70435c030466a12f1d63/minecraftia.zip";
    hash = "sha256-AZFSts0GpBttbhl1LHMORiqqc9o7ZWhh5hbjhSnxAlA=";
    stripRoot = false;
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://fontlibrary.org/en/font/minecraftia";
    description = "Cool Minecraft font";
    license = lib.licenses.cc-by-sa-30;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ gepbird ];
  };
}
