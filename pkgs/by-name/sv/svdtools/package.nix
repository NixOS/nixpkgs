{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.18";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-Pf5OCeIbrVtwEeo6x2xpPpbbAEnHuScC0pUb0NLdtfg=";
  };

  cargoHash = "sha256-nQWxhfupbAE4W4hCn4KOP8MEoTfia+BfgA1QQsV9YyI=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    mainProgram = "svdtools";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
