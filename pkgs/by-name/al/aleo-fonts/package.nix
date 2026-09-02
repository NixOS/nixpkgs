{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "aleo-fonts";
  version = "2.0.0-unstable-2023-06-03";

  src = fetchFromGitHub {
    owner = "AlessioLaiso";
    repo = "aleo";
    rev = "ce875e48d9983031648e87f38b7a269f4fbf5eb5";
    hash = "sha256-HSxP5/sLHQTujBVt1u93625EXEc42lxpt8W1//6ngWM=";
  };

  outputs = [
    "out"
    "webfont"
  ];

  nativeBuildInputs = [ installFonts ];

  preInstall = "rm -r fonts/old";

  meta = {
    description = "Slab serif typeface designed by Alessio Laiso";
    homepage = "https://github.com/AlessioLaiso/aleo";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.all;
  };
}
