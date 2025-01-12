{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.21";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-0ciEhtCJEerzyAcB/3xXnaStXBTi5SWcMplGlft9eeY=";
  };

  cargoHash = "sha256-+YBFjsPY3w+zjLtIB9GQXkuGy1ZHNT86clsQYiXeTJU=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    mainProgram = "svdtools";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ newam ];
  };
}
