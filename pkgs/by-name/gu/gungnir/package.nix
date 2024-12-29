{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gungnir";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "g0ldencybersec";
    repo = "gungnir";
    rev = "v${version}";
    hash = "sha256-iMawBuSPPeJztQ3Pdd2dUKSNaWCbbKcUW/IGBFifyng=";
  };

  vendorHash = "sha256-2RCIZS8oawaXtAYZDiLgNsco9llWCxNwQcA67F51rag=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool that continuously monitors certificate transparency (CT) logs for newly issued SSL/TLS certificates";
    homepage = "https://github.com/g0ldencybersec/gungnir";
    license = licenses.mit;
    maintainers = with maintainers; [ cherrykitten ];
    mainProgram = "gungnir";
  };
}

