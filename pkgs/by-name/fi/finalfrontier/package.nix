{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  libiconv,
  openssl,
}:

rustPlatform.buildRustPackage {
  pname = "finalfrontier";
  version = "unstable-2022-01-06";

  src = fetchFromGitHub {
    owner = "finalfusion";
    repo = "finalfrontier";
    rev = "2461fb1dde13b73039926aa66606e470907a1b59";
    sha256 = "sha256-bnRzXIYairlBjv2JxU16UXYc5BB3VeKZNiJ4+XDzub4=";
  };

  cargoHash = "sha256-AQiXRKOXV7kXiu9GbtPE0Rddy93t1Y5tuJmww4xFSaU=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  postInstall = ''
    installManPage man/*.1

    # Install shell completions
    for shell in bash fish zsh; do
      $out/bin/finalfrontier completions $shell > finalfrontier.$shell
    done
    installShellCompletion finalfrontier.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "Utility for training word and subword embeddings";
    mainProgram = "finalfrontier";
    homepage = "https://github.com/finalfusion/finalfrontier/";
    license = licenses.asl20;
    maintainers = [ ];
    # The last successful Darwin Hydra build was in 2024
    broken = stdenv.hostPlatform.isDarwin;
  };
}
