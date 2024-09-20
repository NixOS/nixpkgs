{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pom";
  version = "0.1.0-unstable-2024-05-17";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "pom";
    rev = "699204a6db4f942ee6a6bf0dc389709ab6e1663f";
    hash = "sha256-Qc4gU2oCgI/B788NuEqB+FoAYZQ84m5K3eArcdz+q20=";
  };

  vendorHash = "sha256-xJNcFX+sZjZwXFTNrhsDnj3eR/r8+NH6tzpEJOhtkeY=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Pomodoro timer in your terminal";
    homepage = "https://github.com/maaslalani/pom";
    license = licenses.mit;
    maintainers = with maintainers; [ maaslalani redyf  ];
    mainProgram = "pom";
  };
}
