{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kode-mono";
  version = "1.207";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchzip {
    url = "https://github.com/isaozler/kode-mono/releases/download/${finalAttrs.version}/kode-mono-${finalAttrs.version}.zip";
    hash = "sha256-C1RM61qUEdX81t26nYCa2tnFq3tKR1DSZ8I3FUIbFiQ=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Custom-designed typeface explicitly created for the developer community";
    homepage = "https://kodemono.com/";
    changelog = "https://github.com/isaozler/kode-mono/blob/main/CHANGELOG.md";
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.isaozler ];
    platforms = lib.platforms.all;
  };
})
