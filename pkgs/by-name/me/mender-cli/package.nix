{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
  stdenv,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "mender-cli";
  version = "2.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mendersoftware";
    repo = "mender-cli";
    tag = finalAttrs.version;
    hash = "sha256-jFWC1g/ebgMIqgBFgotBDwPcGNmAK3VsvfjiuRCN1ws=";
  };

  vendorHash = "sha256-vlcq9HGezJsorwsaVwvIKxi1pSoo4wTPmc6qCCVDdfI=";

  ldflags = [ "-s" ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh powershell; do
      installShellCompletion --cmd mender-cli --"$shell" <("$out/bin/mender-cli" completion "$shell")
    done
  '';

  meta = {
    description = "A general-purpose CLI for the Mender backend";
    homepage = "https://github.com/mendersoftware/mender-cli";
    changelog = "https://github.com/mendersoftware/mender-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ MoritzBoehme ];
    mainProgram = "mender-cli";
  };
})
