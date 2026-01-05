{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "levant";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "levant";
    rev = "v${version}";
    sha256 = "sha256-XxdLN/z+mtiaAy6heRbj4kyIOeKbS9yb1xIZnIyfI3s=";
  };

  vendorHash = "sha256-UJuAT02rYid2IESuABTDEAJiIBOfcyvH7ASOZfgTrZs=";

  # The tests try to connect to a Nomad cluster.
  doCheck = false;

  meta = with lib; {
    description = "Open source templating and deployment tool for HashiCorp Nomad jobs";
    mainProgram = "levant";
    homepage = "https://github.com/hashicorp/levant";
    license = licenses.mpl20;
    maintainers = with maintainers; [ max-niederman ];
  };
}
