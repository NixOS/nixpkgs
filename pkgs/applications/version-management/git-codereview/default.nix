{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "git-codereview";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "review";
    rev = "v${version}";
    hash = "sha256-vq/rrDOZUn/apHgk6YPnfG7hmKRSapuw49ZyFVMWNqs=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  nativeCheckInputs = [ git ];

  meta = with lib; {
    description = "Manage the code review process for Git changes using a Gerrit server";
    homepage = "https://golang.org/x/review/git-codereview";
    license = licenses.bsd3;
    maintainers = [ maintainers.edef ];
  };
}
