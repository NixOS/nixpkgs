{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "hermit";
  version = "0.39.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cashapp";
    repo = "hermit";
    hash = "sha256-BXh9HWCFeAs/S5z1ru+31mndsvt1DVh1Q7SeGzB4Rzk=";
  };

  vendorHash = "sha256-1QMZvxy6cCJVoIP8mG7s4V0nBAGhrHoPbiKKyYDDL2g=";

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
