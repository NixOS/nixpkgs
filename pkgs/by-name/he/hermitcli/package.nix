{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "hermit";
  version = "0.39.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cashapp";
    repo = "hermit";
    hash = "sha256-By6ZWOiv1A7wghIGD6+oGoBic9puo4M+DzsM/7fOpy8=";
  };

  vendorHash = "sha256-vEv/sciynvxQE7KpxqpaSO1p5R3xYBK6o4EeuJ2JYmg=";

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
