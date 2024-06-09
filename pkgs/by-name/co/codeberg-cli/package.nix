{
  darwin,
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
  version = "0.4.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "RobWalt";
    repo = "codeberg-cli";
    rev = "v${version}";
    hash = "sha256-g5V3Noqh7Y9v/t/dt7n45/NblqNtpZCKELPc9DOkb8A=";
  };

  cargoHash = "sha256-zTg/3PcFWzBmKZA7lRIpM3P03d1qpNVBczqWFbnxpic=";
  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin (
      let
        d = darwin.apple_sdk.frameworks;
      in
      [
        d.CoreServices
        d.Security
        d.SystemConfiguration
      ]
    );

  postInstall = ''
    installShellCompletion --cmd berg \
      --bash <($out/bin/berg completion bash) \
      --fish <($out/bin/berg completion fish) \
      --zsh <($out/bin/berg completion zsh)
  '';

  meta = with lib; {
    description = "CLI Tool for Codeberg similar to gh and glab";
    homepage = "https://codeberg.org/RobWalt/codeberg-cli";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ robwalt ];
    mainProgram = "berg";
  };
}
