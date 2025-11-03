{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pizauth";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "pizauth";
    tag = "pizauth-${finalAttrs.version}";
    hash = "sha256-KLHccRCJ19CrGKePhUgW4GhQzn+ULE861cW2ykGoaZk=";
  };

  cargoHash = "sha256-m1kOV0b/HCSAGfbEh4GdtrlphoELe7ebG+kgKKNYihY=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd pizauth \
      --bash share/bash/completion.bash \
      --fish share/fish/pizauth.fish
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line OAuth2 authentication daemon";
    homepage = "https://github.com/ltratt/pizauth";
    changelog = "https://github.com/ltratt/pizauth/blob/${finalAttrs.src.rev}/CHANGES.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "pizauth";
  };
})
