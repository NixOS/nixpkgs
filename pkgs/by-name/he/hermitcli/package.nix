{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "hermit";
  version = "0.44.9";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cashapp";
    repo = "hermit";
    hash = "sha256-nnDpwVYQvNxCH05DQboRTeyDBIWmdgU9qQD1mD9cSqE=";
  };

  vendorHash = "sha256-9WaAyf1DHoQRW+m8sgH9eQoHBSDDvqDsGy40mkmdhFA=";

  subPackages = [ "cmd/hermit" ];

  ldflags = [
    "-X main.version=${version}"
    "-X main.channel=stable"
  ];

  meta = with lib; {
    homepage = "https://cashapp.github.io/hermit";
    description = "Manages isolated, self-bootstrapping sets of tools in software projects";
    license = licenses.asl20;
    maintainers = with maintainers; [ cbrewster ];
    platforms = platforms.unix;
    mainProgram = "hermit";
  };
}
