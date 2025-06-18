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
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "altsem";
    repo = "gitu";
    rev = "v${version}";
    hash = "sha256-9rJa6nXz9gzEVAVkvIghMaND7MY84dLHLV6Kr/ApEnU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QN+AU9Qsqx2l2vwpANkMhycv2qFzjCQoxFgbP9WVpOk=";

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
