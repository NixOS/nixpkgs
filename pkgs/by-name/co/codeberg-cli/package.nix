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
  version = "0.4.9";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Aviac";
    repo = "codeberg-cli";
    rev = "v${version}";
    hash = "sha256-uifLgXwKcdZ8Q2GjVIa/EA5iq+T9pm821aKsXPbPL34=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nKI0bIKocTjodZ6O1VTTTrlzeeueaH6crF9jdTnx5lI=";
  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      let
        d = darwin.apple_sdk.frameworks;
      in
      [
        d.CoreServices
        d.Security
        d.SystemConfiguration
      ]
    );

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
