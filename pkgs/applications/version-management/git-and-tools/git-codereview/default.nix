{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "git-codereview";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "review";
    rev = "v${version}";
    sha256 = "sha256-Hyo2UWGlxxeSz3E73DeA0VoOnBJ1VedvpshnATJGbFo=";
  };

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  ldflags = [ "-s" "-w" ];

  checkInputs = [ git ];

  meta = with lib; {
    description = "Manage the code review process for Git changes using a Gerrit server";
    homepage = "https://golang.org/x/review/git-codereview";
    license = licenses.bsd3;
    maintainers = [ maintainers.edef ];
  };
}
