{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nomino";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "yaa110";
    repo = "nomino";
    rev = version;
    hash = "sha256-pSk1v4AyXETBJ8UupLJy8cNEqKRwkqJnqfzoHU0SdmE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-P8QkAzZ7jR8U+WzMLo4kDwMrARLk+RQWOr/j+8GCN0A=";

  meta = with lib; {
    description = "Batch rename utility for developers";
    homepage = "https://github.com/yaa110/nomino";
    changelog = "https://github.com/yaa110/nomino/releases/tag/${src.rev}";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "nomino";
  };
}
