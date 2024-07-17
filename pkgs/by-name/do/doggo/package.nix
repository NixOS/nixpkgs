{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

buildGoModule rec {
  pname = "doggo";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "mr-karan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hzl7BE3vsE2G9O2nwN/gkqQTJ+9aDfNIjmpmgN1AYq8=";
  };

  vendorHash = "sha256-uonybBLABPj9CPtc+y82ajvQI7kubK+lKi4eLcZIUqA=";
  nativeBuildInputs = [ installShellFiles ];
  subPackages = [ "cmd/doggo" ];

  ldflags = [
    "-w -s"
    "-X main.buildVersion=v${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd doggo \
      --fish --name doggo.fish completions/doggo.fish \
      --zsh --name _doggo completions/doggo.zsh
  '';

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
