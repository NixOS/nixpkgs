{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gungnir";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "g0ldencybersec";
    repo = "gungnir";
    rev = "v${version}";
    hash = "sha256-a3qELEkScfqrAS5di4+k+mvUf/VHV+z16Ns2zHwSUHo=";
  };

  vendorHash = "sha256-heuJZbWZBEt4GvkixaYdgRb8mAj6w7dp4ZvdQYzs89U=";

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
