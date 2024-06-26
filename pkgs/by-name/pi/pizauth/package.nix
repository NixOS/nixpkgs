{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "pizauth";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "pizauth";
    rev = "pizauth-${version}";
    hash = "sha256-Du+MVdYVQgH2V7928kpur+Xp/0y7HXgB8ZC0qciiQvs=";
  };

  cargoHash = "sha256-DrpYMVGvu7UnzQToVgVptURqp7XyoR1iYUfRSLZaqXw=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  postInstall = ''
    installShellCompletion --cmd pizauth \
      --bash share/bash/completion.bash
  '';

  meta = {
    description = "Command-line OAuth2 authentication daemon";
    homepage = "https://github.com/ltratt/pizauth";
    changelog = "https://github.com/ltratt/pizauth/blob/${src.rev}/CHANGES.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "pizauth";
  };
}
