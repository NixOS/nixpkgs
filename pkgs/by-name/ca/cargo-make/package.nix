{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  bzip2,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.37.24";

  src = fetchFromGitHub {
    owner = "sagiegurari";
    repo = "cargo-make";
    rev = version;
    hash = "sha256-hrUd4J15cDyd78BVVzi8jiDqJI1dE35WUdOo6Tq8gH8=";
  };

  cargoHash = "sha256-ml/OW4S4fIMLmm7vVPgsXB7CigDYORGFpN3jZRp1f8c=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    bzip2
    openssl
  ];

  postInstall = ''
    installShellCompletion extra/shell/*.bash
  '';

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also:
  #   https://travis-ci.org/sagiegurari/cargo-make
  doCheck = false;

  meta = {
    description = "Rust task runner and build tool";
    homepage = "https://github.com/sagiegurari/cargo-make";
    changelog = "https://github.com/sagiegurari/cargo-make/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      figsoda
      xrelkd
    ];
    mainProgram = "cargo-make";
  };
}
