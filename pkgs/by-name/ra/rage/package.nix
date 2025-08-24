{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "rage";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = "rage";
    rev = "v${version}";
    hash = "sha256-aZs1iqfpsiMuhxXNqRatpKD99eDBCsWHk4OPpnnaB70=";
  };

  cargoHash = "sha256-GdvqkB/jHAGUbzhOLPkIX664JJH3WrZZtv+/E/PhTR8=";

  nativeBuildInputs = [
    installShellFiles
  ];

  # cargo test has an x86-only dependency
  doCheck = stdenv.hostPlatform.isx86;

  postInstall = ''
    installManPage target/*/release/manpages/man1/*
    installShellCompletion \
      --bash target/*/release/completions/*.bash \
      --fish target/*/release/completions/*.fish \
      --zsh target/*/release/completions/_*
  '';

  meta = {
    description = "Simple, secure and modern encryption tool with small explicit keys, no config options, and UNIX-style composability";
    homepage = "https://github.com/str4d/rage";
    changelog = "https://github.com/str4d/rage/blob/v${version}/rage/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ]; # either at your option
    maintainers = with lib.maintainers; [ ryantm ];
    mainProgram = "rage";
  };
}
