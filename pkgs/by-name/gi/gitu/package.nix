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
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "altsem";
    repo = "gitu";
    rev = "v${version}";
    hash = "sha256-eOt16jeWLQ7nxKMBwwDs/4NIf/rzr+q6s0QHcY+zzSk=";
  };

  cargoHash = "sha256-pJs8uTim+/TrqzjxCzKHlaZRQudd0dMIZXqlAZU7G1M=";

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
