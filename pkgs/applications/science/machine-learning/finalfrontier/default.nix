{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  libiconv,
  openssl,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "finalfrontier";
  version = "unstable-2022-01-06";

  src = fetchFromGitHub {
    owner = "finalfusion";
    repo = pname;
    rev = "2461fb1dde13b73039926aa66606e470907a1b59";
    sha256 = "sha256-bnRzXIYairlBjv2JxU16UXYc5BB3VeKZNiJ4+XDzub4=";
  };

  cargoHash = "sha256-C/D9EPfifyajrCyXE8w/qRuzWEoyJJIcj4xii94/9l4=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      Security
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
  };
}
