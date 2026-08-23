{
  lib,
  fetchFromCodeberg,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsname";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "poacher";
    repo = "rsname";
    rev = "611c610ef8bf18ede56b772779f6848788b647e4";
    hash = "sha256-8KJSBZP6H9GL9aQn3IpuY2WKRu/jlBplBGO1Xg2gE/8=";
  };

  cargoHash = "sha256-ZvzCDwptWye4jQBBAGCn3x8u1/wf5KEj+jmRDVSS0iY=";

  meta = {
    description = "Rename files on the command line";
    homepage = "https://codeberg.org/poacher/rsname";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ poacher ];
    mainProgram = "rn";
    platforms = lib.platforms.all;
  };
})
