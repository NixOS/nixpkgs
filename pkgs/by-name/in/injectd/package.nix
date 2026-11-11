{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "injectd";
  version = "1.0.1";

  src = fetchFromCodeberg {
    owner = "b6d5b38e0d7ae6bd0d951815cd92df43";
    repo = "injectd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mBnMTiak0dyD9nWwjvbNFm18K2KqWcbonOd2Vl/3g2E=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Tool to inject custom boot messages into the console";
    homepage = "https://codeberg.org/b6d5b38e0d7ae6bd0d951815cd92df43/injectd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b6d5b38e0d7ae6bd0d951815cd92df43 ];
    mainProgram = "injectd";
    platforms = lib.platforms.linux;
  };
})
