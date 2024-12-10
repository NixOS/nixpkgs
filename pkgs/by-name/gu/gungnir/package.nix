{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gungnir";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "g0ldencybersec";
    repo = "gungnir";
    rev = "v${version}";
    hash = "sha256-k6fxAvUBAAcTHzdeGhekYhPpnS05jHq/7EqxafQfMio=";
  };

  vendorHash = "sha256-r2aU59L0fnSdc/lpR04K/GQ1eZ7ihV+tKlyuS6sPX2o=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "A command-line tool that continuously monitors certificate transparency (CT) logs for newly issued SSL/TLS certificates";
    homepage = "https://github.com/g0ldencybersec/gungnir";
    license = licenses.mit;
    maintainers = with maintainers; [ cherrykitten ];
    mainProgram = "gungnir";
  };
}
