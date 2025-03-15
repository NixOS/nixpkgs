{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdsh";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    hash = "sha256-MCudMeiqEbzOL9m50hccvogAUBaUeILm/Hu4nH04GXU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-73wlW8Zat3/crJIcfqZ/9mCPxGDXH+A+3jvYZBHDjUk=";

  meta = with lib; {
    description = "Markdown shell pre-processor";
    homepage = "https://github.com/zimbatm/mdsh";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
    mainProgram = "mdsh";
  };
}
