{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "doggo";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "mr-karan";
    repo = "doggo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yKEjTaDwJVycsGeoJTVMjN9D4AzRLXZAY5fVIp+B14c=";
  };

  vendorHash = "sha256-ybI17J5EKvigBapt8Ed2FuMEzGUVzEpJ6OTVYWXVOOc=";
  nativeBuildInputs = [ installShellFiles ];
  subPackages = [ "cmd/doggo" ];

  ldflags = [
    "-s"
    "-X main.buildVersion=v${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd doggo \
      --bash <($out/bin/doggo completions bash) \
      --fish <($out/bin/doggo completions fish) \
      --zsh <($out/bin/doggo completions zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/mr-karan/doggo";
    description = "Command-line DNS Client for Humans. Written in Golang";
    mainProgram = "doggo";
    longDescription = ''
      doggo is a modern command-line DNS client (like dig) written in Golang.
      It outputs information in a neat concise manner and supports protocols like DoH, DoT, DoQ, and DNSCrypt as well
    '';
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      georgesalkhouri
      ma27
    ];
  };
})
