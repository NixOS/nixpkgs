{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pizauth";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "pizauth";
    tag = "pizauth-${finalAttrs.version}";
    hash = "sha256-RrmRdJOYvQ9/DaNXH8fQ3BCNdYba/6HcsT3EAV1qoNA=";
  };

  cargoHash = "sha256-ZY1BcunsR4i8QomRrh9yKdH7CP84Wl7UGUZQ8LUCd68=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd pizauth \
      --bash share/bash/completion.bash \
      --fish share/fish/pizauth.fish

    installManPage pizauth.1 pizauth.conf.5

    substituteInPlace lib/systemd/user/pizauth.service \
      --replace-fail /usr/bin/pizauth "$out/bin/pizauth"
    install -Dm444 lib/systemd/user/pizauth{,-*}.service -t $out/lib/systemd/user
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=pizauth-(.*)" ]; };

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
