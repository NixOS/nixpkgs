{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.6.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-nsixj/zskHNIkv/qiD1DvrjeqkzVuN76tH+vCLGvPW8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-HAbL/3StlK+VlonoviB2hFxCj7oyG93ReUytE3pFOMQ=";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    mainProgram = "b3sum";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [
      fpletz
      ivan
    ];
    license = with lib.licenses; [
      cc0
      asl20
    ];
    changelog = "https://github.com/BLAKE3-team/BLAKE3/releases/tag/${version}";
  };
}
