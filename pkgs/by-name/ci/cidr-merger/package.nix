{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cidr-merger";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "zhanhb";
    repo = "cidr-merger";
    rev = "v${version}";
    hash = "sha256-Kb+89VP7JhBrTE4MM3H/dqoIBgDLnVhKqkgHdymYCgk=";
  };

  vendorHash = "sha256-cPri384AX/FdfNtzt3xj4bF+/izSa4sZuAohK0R/7H4=";

  meta = with lib; {
    description = "Simple command line tool to merge ip/ip cidr/ip range, supports IPv4/IPv6";
    mainProgram = "cidr-merger";
    homepage = "https://github.com/zhanhb/cidr-merger";
    license = licenses.mit;
    maintainers = with maintainers; [ cyounkins ];
  };
}
