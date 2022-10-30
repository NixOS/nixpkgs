{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gickup";
  version = "0.10.10";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = pname;
    rev = "v${version}";
    sha256 = "ZN8QbVOGrBmIplg9h2WRjrIKwtMwOr4yPblIlTXG2AY=";
  };

  ldflags = [ "-X" "main.version=v${version}" ];
  vendorSha256 = "wpGNxMATe0muHhuEtRUj3S9ougK0BHvv6hiYi3xeP1E=";

  meta = with lib; {
    description = "A tool to backup all your favorite repos";
    homepage = "https://github.com/cooperspencer/gickup";
    license = licenses.asl20;
    maintainers = with maintainers; [ mtoohey ];
  };
}
