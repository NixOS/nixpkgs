{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "hermit";
  version = "0.39.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cashapp";
    repo = "hermit";
    hash = "sha256-Cp96OOAEwBz83Fsex7DeI5LSp1gBhP8VP0I6bJAZC4U=";
  };

  vendorHash = "sha256-vEv/sciynvxQE7KpxqpaSO1p5R3xYBK6o4EeuJ2JYmg=";

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
