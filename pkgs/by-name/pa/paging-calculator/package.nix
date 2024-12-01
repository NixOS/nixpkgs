{ fetchCrate
, lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "paging-calculator";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-mTHBARrcq8cJxzh80v/fGr5vACAMyy/DhN8zpQTV0jM=";
  };

  cargoHash = "sha256-oQQA+AGsuMKaFhoZRuv3BASCLJwfgbrdK+2noxBLm7k=";

  meta = {
    description = "CLI utility that helps calculating page table indices from a virtual address";
    mainProgram = "paging-calculator";
    longDescription = ''
      paging-calculator is a CLI utility written in Rust that helps you finding the indices that a
      virtual address will have into the page tables on different architectures.

      It takes a (virtual) address in hexadecimal format and shows you which index is used for
      which level of the page table.
    '';
    homepage = "https://github.com/phip1611/paging-calculator";
    changelog = "https://github.com/phip1611/paging-calculator/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ phip1611 ];
  };
}
