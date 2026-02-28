{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pizauth";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "pizauth";
    tag = "pizauth-${finalAttrs.version}";
    hash = "sha256-wdR/7gV/2U+MsncbQ6Gy2na5YuBp4F2H8ohij+Dfvcs=";
  };

  cargoHash = "sha256-AvUaeevnV5fIeEKXQAY1IGHcV3l3lTwFmFKsaEPbr+4=";

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
