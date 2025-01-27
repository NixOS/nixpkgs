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
  version = "0.4.7";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Aviac";
    repo = "codeberg-cli";
    rev = "v${version}";
    hash = "sha256-GFUBMriBHKWjgT10Vvpa8FMqB6CvksSPoFBBr3uwrrg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZOPfCrWlJXL+XipEngLSIqryEAou5A8mTtZgA5gabc4=";
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
