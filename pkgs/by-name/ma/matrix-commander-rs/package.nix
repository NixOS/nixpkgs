{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "matrix-commander-rs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander-rs";
    tag = "v${version}";
    hash = "sha256-CvsMRxB5s891cVu03RroTQYOGA6rmhpif8VT0njXTnc=";
  };

  cargoHash = "sha256-hzWq09qJTox8yZuMOQ1///hKxY4EsWn/mHKy3svxlF8=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [ openssl ];

  meta = {
    description = "CLI-based Matrix client app for sending and receiving";
    homepage = "https://github.com/8go/matrix-commander-rs";
    changelog = "https://github.com/8go/matrix-commander-rs/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "matrix-commander-rs";
  };
}
