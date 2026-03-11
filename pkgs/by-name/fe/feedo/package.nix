{
  lib,
  fetchCrate,
  rustPlatform,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "feedo";
  version = "1.1.31";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-GMXCvKJcz4uowsphCaSTPdp1ijBlP2Oxpqlph7VX6hw=";
  };

  cargoHash = "sha256-SdN6R7TAdG086VsBSQRnxkgjYrTyQ1oT0zPgEmElAJc=";

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "A terminal RSS Reader";
    homepage = "https://github.com/ricardodantas/feedo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rachitvrma ];
  };
}
