{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "hoard";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Hyde46";
    repo = "hoard";
    rev = "v${version}";
    hash = "sha256-c9iSbxkHwLOeATkO7kzTyLD0VAwZUzCvw5c4FyuR5/E=";
  };

  cargoHash = "sha256-+XZL0a7/9Ic6cmym3ctwmGMu4xjGPCA2E7OrBj7Bfvw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "CLI command organizer written in rust";
    homepage = "https://github.com/hyde46/hoard";
    changelog = "https://github.com/Hyde46/hoard/blob/${src.rev}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      builditluc
      figsoda
    ];
    mainProgram = "hoard";
  };
}
