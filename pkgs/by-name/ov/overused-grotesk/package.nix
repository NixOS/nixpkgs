{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "overused-grotesk";
  version = "0.5-alpha.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/RandomMaerks/Overused-Grotesk/releases/download/v${finalAttrs.version}/OverusedGrotesk-v${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-XNylWbD9ZjEAcIUNCQECEy4ATlTlrzXrKP4Fb5YSCUw=";
  };

  nativeBuildInputs = [ installFonts ];

  sourceRoot = "${finalAttrs.src.name}/ttf";

  meta = {
    homepage = "https://randommaerks.github.io/overused-grotesk";
    changelog = "https://github.com/RandomMaerks/Overused-Grotesk/releases";
    description = "A variable sans serif typeface inspired by the classic neo-grotesk Swiss design";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ yarn ];
  };
})
