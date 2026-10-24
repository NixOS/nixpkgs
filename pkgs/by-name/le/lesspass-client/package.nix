{
  lib,
  fetchFromGitLab,
  rustPlatform,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "lesspass-client";
  version = "0.9.0";

  src = fetchFromGitLab {
    owner = "ogarcia";
    repo = "lesspass-client";
    tag = version;
    hash = "sha256-ugmnwN/YDoDrcl2u6O+fMfZdHW9raojy0op6F8KSzCs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-P0VMeul9j41FRVbBzR+TLa85iJ/ETjlw9ZDecdxTRCs=";

  nativeBuildInputs = [
    openssl
  ];

  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_DIR = "${lib.getDev openssl}";

  meta = {
    description = "LessPass API client library and CLI written in Rust";
    homepage = "https://gitlab.com/ogarcia/lesspass-client";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ arbel-arad ];
    mainProgram = "lesspass-client";
  };
}
