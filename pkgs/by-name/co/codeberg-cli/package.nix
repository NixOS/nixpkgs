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
  version = "0.4.6";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Aviac";
    repo = "codeberg-cli";
    rev = "v${version}";
    hash = "sha256-BkWI4FbacgFrbSLNSqe7vdzdLvrrgX1528qFaKCd5tY=";
  };

  cargoHash = "sha256-eFS16QzPMLhoVb+hqt/p3ka58rwP5WTgHas2PZT5c/U=";
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
