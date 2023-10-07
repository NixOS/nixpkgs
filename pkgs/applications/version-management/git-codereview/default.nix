{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "git-codereview";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "review";
    rev = "v${version}";
    hash = "sha256-oHW73Y31z+0jOJdSJJa550mJYV8IP2fN+oNwT+3sySM=";
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
