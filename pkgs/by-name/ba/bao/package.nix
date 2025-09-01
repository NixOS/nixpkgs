{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "bao";
  version = "0.13.1";

  src = fetchCrate {
    inherit version;
    pname = "${pname}_bin";
    hash = "sha256-8h5otpu3z2Hgy0jMCITJNr8Q4iVdlR5Lea2X+WuenWs=";
  };

  cargoHash = "sha256-B0wvJTcIRJxBU0G1DONnKeQYrmsmMIorhTLc73o4/kE=";

  meta = {
    description = "Implementation of BLAKE3 verified streaming";
    homepage = "https://github.com/oconnor663/bao";
    maintainers = with lib.maintainers; [ amarshall ];
    license = with lib.licenses; [
      cc0
      asl20
    ];
    mainProgram = "bao";
  };
}
