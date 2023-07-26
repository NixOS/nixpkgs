{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "git-codereview";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "review";
    rev = "v${version}";
    hash = "sha256-Dy7gHT6WmZ1TjA5s+VmOUkaRvrA9v7mWQSLPscgBHgY=";
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
