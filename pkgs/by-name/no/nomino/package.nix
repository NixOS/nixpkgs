{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nomino";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "yaa110";
    repo = "nomino";
    rev = version;
    hash = "sha256-DZTJng5aVYi14nojQ6G9+JkqSd9kn6yEYrwQbR8cd2M=";
  };

  cargoHash = "sha256-jXDbQEUzQ5E7lcutdvQMpyMfuILcJTFvQgq7rNI/XmM=";

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
