{ buildGoModule
, fetchFromGitHub
, installShellFiles
, nix-update-script
, lib
}:

buildGoModule rec {
  pname = "doggo";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "mr-karan";
    repo = "doggo";
    rev = "v${version}";
    hash = "sha256-SD/BcJxoc5Oi8+nAs+CWBEcbgtaohykNlZ14jJvEWew=";
  };

  vendorHash = "sha256-JIc6/G1hMf8+oIe4OMc+b0th5MCgi5Mwp3AxW4OD1lg=";
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
    maintainers = with maintainers; [ georgesalkhouri ];
  };
}
