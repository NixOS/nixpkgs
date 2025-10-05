{
  fetchFromGitea,
  installShellFiles,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "codeberg-cli";
  version = "0.5.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Aviac";
    repo = "codeberg-cli";
    rev = "v${version}";
    hash = "sha256-81435dgw7fy4igUN3TYNjRans8uRZ/6TQWBxu0benwU=";
  };

  cargoHash = "sha256-1E7UuDbJKrnhMQI6trk7nHkeywCPFg1021pQhRcb4kQ=";
  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ openssl ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd berg \
      --bash <($out/bin/berg completion bash) \
      --fish <($out/bin/berg completion fish) \
      --zsh <($out/bin/berg completion zsh)
  '';

  meta = with lib; {
    description = "CLI Tool for Codeberg similar to gh and glab";
    homepage = "https://codeberg.org/Aviac/codeberg-cli";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ robwalt ];
    mainProgram = "berg";
  };
}
