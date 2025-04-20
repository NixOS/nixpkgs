{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitu";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "altsem";
    repo = "gitu";
    rev = "v${version}";
    hash = "sha256-c2YVcE+a/9Z6qTLEbcSFE6393SEeudyvdbzCRJfszcc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+tSNUtsDFKqx5W8+cuxyFsG1etm44eYgoYuoUt5tw3E=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  nativeCheckInputs = [
    git
  ];

  meta = with lib; {
    description = "TUI Git client inspired by Magit";
    homepage = "https://github.com/altsem/gitu";
    changelog = "https://github.com/altsem/gitu/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ evanrichter ];
    mainProgram = "gitu";
  };
}
