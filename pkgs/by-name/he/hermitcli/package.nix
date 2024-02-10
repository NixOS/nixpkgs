{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "hermit";
  version = "0.38.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cashapp";
    repo = "hermit";
    hash = "sha256-cBVTIpY85lrKJ1bX1mIlUW1oWEHgg8wjdUh+0FHUp80=";
  };

  vendorHash = "sha256-W8n7WA1gHx73jHF69apoKnDCIKlbWkj5f1wVITt7F+M=";

  subPackages = [ "cmd/hermit" ];

  ldflags = [
    "-X main.version=${version}"
    "-X main.channel=stable"
  ];

  meta = with lib; {
    homepage = "https://cashapp.github.io/hermit";
    description = "Manages isolated, self-bootstrapping sets of tools in software projects.";
    license = licenses.asl20;
    maintainers = with maintainers; [ cbrewster ];
    platforms = platforms.unix;
    mainProgram = "hermit";
  };
}
