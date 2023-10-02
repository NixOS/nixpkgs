{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
}:

buildGoModule rec {
  pname = "gnmic";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "openconfig";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aEAbIh1BH8R05SpSMSXL2IrudjIki72k7NGvjjKkxZw=";
  };

  vendorHash = "sha256-hIG3kG2e9Y2hnHJ+96cPLgnlp5ParsLgWQY0HZTDggY=";

  ldflags = [
    "-s" "-w"
    "-X" "github.com/openconfig/gnmic/app.version=${version}"
    "-X" "github.com/openconfig/gnmic/app.commit=${src.rev}"
    "-X" "github.com/openconfig/gnmic/app.date=1970-01-01T00:00:00Z"
  ];
  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = let emulator = stdenv.hostPlatform.emulator buildPackages; in ''
    installShellCompletion --cmd gnmic \
      --bash <(${emulator} $out/bin/gnmic completion bash) \
      --fish <(${emulator} $out/bin/gnmic completion fish) \
      --zsh  <(${emulator} $out/bin/gnmic completion zsh)
  '';

  meta = with lib; {
    description = "gNMI CLI client and collector";
    homepage = "https://gnmic.openconfig.net/";
    changelog = "https://github.com/openconfig/gnmic/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ vincentbernat ];
  };
}
