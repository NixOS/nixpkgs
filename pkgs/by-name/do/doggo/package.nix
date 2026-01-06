{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule rec {
  pname = "doggo";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "mr-karan";
    repo = "doggo";
    rev = "v${version}";
    hash = "sha256-wraqaztGZHkldWL3tesclqQzOy4B7T/Vg18A1guFvOc=";
  };

  vendorHash = "sha256-+tuMDQnbW3kjpVhck3aSMw1+Rv8aCzdOqD4KD7KX3G8=";
  nativeBuildInputs = [ installShellFiles ];
  subPackages = [ "cmd/doggo" ];

  ldflags = [
    "-s"
    "-X main.buildVersion=v${version}"
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
}
