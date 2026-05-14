{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pizauth";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "pizauth";
    tag = "pizauth-${finalAttrs.version}";
    hash = "sha256-e9YBeYMC9tfxZoXZi/QBW3FO5V6BAe7RSvVWs7rv0PI=";
  };

  cargoHash = "sha256-9cDVbDCb8vY6KxreyiMX3gp13bXZpxTQOwYbk6TEVpc=";

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
