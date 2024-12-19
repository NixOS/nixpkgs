{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "bao";
  version = "0.12.1";

  src = fetchCrate {
    inherit version;
    pname = "${pname}_bin";
    hash = "sha256-+MjfqIg/aKPWhzxbPJ0dnS4egCj50Ib7ob3zXUSBXRg=";
  };

  cargoPatches = [
    # https://github.com/oconnor663/bao/pull/55
    ./test-exe.patch
  ];

  cargoHash = "sha256-mmhTG3WXVjIKtaz2xP9aYI9GQNTbx4l3c6UgKSMgQJU=";

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
