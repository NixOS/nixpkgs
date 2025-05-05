{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gungnir";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "g0ldencybersec";
    repo = "gungnir";
    rev = "v${version}";
    hash = "sha256-42qaVLEFAV6/6xMVM+mLi0Acp26AKOHvs4EUK2y09as=";
  };

  vendorHash = "sha256-O4KPbPtZhUMYsTyefPh5ok0JWY10cw8XhPvEGX2gMzY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Command-line tool that continuously monitors certificate transparency (CT) logs for newly issued SSL/TLS certificates";
    homepage = "https://github.com/g0ldencybersec/gungnir";
    license = licenses.mit;
    maintainers = with maintainers; [ cherrykitten ];
    mainProgram = "gungnir";
  };
}
