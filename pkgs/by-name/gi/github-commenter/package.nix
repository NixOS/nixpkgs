{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "github-commenter";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = pname;
    rev = version;
    hash = "sha256-x3/ae22ub9Us3mvSmvq9ohlkujvZCUfSrmZeQNvIWzE=";
  };

  vendorHash = "sha256-DS2cTYQasIKmyqHS3kTpNMA4fuLxSv4n7ZQjeRWE0gI=";

  meta = with lib; {
    description = "Command line utility for creating GitHub comments on Commits, Pull Request Reviews or Issues";
    mainProgram = "github-commenter";
    license = licenses.asl20;
    homepage = "https://github.com/cloudposse/github-commenter";
    maintainers = [ maintainers.mmahut ];
  };
}
