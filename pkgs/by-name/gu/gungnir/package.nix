{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gungnir";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "g0ldencybersec";
    repo = "gungnir";
    rev = "v${version}";
    hash = "sha256-A4MPRsUSeYwKlhCHByty6T33wEp/BopZMDWOnOqlQqQ=";
  };

  vendorHash = "sha256-r2aU59L0fnSdc/lpR04K/GQ1eZ7ihV+tKlyuS6sPX2o=";

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
