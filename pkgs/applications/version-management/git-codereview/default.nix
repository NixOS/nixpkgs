{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "git-codereview";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "review";
    rev = "v${version}";
    sha256 = "sha256-vh2XFzvGEMutlaHKNhpuYdlnNl49zoNPkLYNUA1lWwc=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" ];

  nativeCheckInputs = [ git ];

  meta = with lib; {
    description = "Manage the code review process for Git changes using a Gerrit server";
    homepage = "https://golang.org/x/review/git-codereview";
    license = licenses.bsd3;
    maintainers = [ maintainers.edef ];
  };
}
