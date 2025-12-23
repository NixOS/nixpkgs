{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "gobgp";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
    sha256 = "sha256-Lm0nJfvXGoRBu6Yv698zf74/xOfG7UagzvTExK6KXbo=";
  };

  vendorHash = "sha256-y8nhrKQnTXfnDDyr/xZd5b9ccXaM85rd8RKHtoDBuwI=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];

  subPackages = [ "cmd/gobgp" ];

  meta = {
    description = "CLI tool for GoBGP";
    homepage = "https://osrg.github.io/gobgp/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ higebu ];
    mainProgram = "gobgp";
  };
}
