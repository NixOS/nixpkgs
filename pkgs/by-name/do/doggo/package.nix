{ buildGoModule
, fetchFromGitHub
, installShellFiles
, nix-update-script
, lib
}:

buildGoModule rec {
  pname = "doggo";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "mr-karan";
    repo = "doggo";
    rev = "v${version}";
    hash = "sha256-SbTwVvE699MCgfUXifnJ1oMNN8TdLg8P03Xx5hrQxF8=";
  };

  vendorHash = "sha256-44gBPMr6gKaRaq7W69K7OBTVXvsz9pSEL1eOKYd4fT8=";
  nativeBuildInputs = [ installShellFiles ];
  subPackages = [ "cmd/doggo" ];

  ldflags = [
    "-s"
    "-X main.buildVersion=v${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd doggo \
      --bash <($out/bin/doggo completions bash) \
      --fish <($out/bin/doggo completions fish) \
      --zsh <($out/bin/doggo completions zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/mr-karan/doggo";
    description = "Command-line DNS Client for Humans. Written in Golang";
    mainProgram = "doggo";
    longDescription = ''
      doggo is a modern command-line DNS client (like dig) written in Golang.
      It outputs information in a neat concise manner and supports protocols like DoH, DoT, DoQ, and DNSCrypt as well
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ georgesalkhouri ma27 ];
  };
}
