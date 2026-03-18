{
  lib,
  fetchCrate,
  rustPlatform,
  writableTmpDirAsHomeHook,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "feedo";
  version = "1.1.31";

  src = fetchCrate {
    inherit (finalAttrs) pname;
    inherit (finalAttrs) version;
    hash = "sha256-GMXCvKJcz4uowsphCaSTPdp1ijBlP2Oxpqlph7VX6hw=";
  };

  cargoHash = "sha256-SdN6R7TAdG086VsBSQRnxkgjYrTyQ1oT0zPgEmElAJc=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  meta = {
    description = "Terminal RSS Reader";
    homepage = "https://github.com/ricardodantas/feedo";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ rachitvrma ];
  };
})
