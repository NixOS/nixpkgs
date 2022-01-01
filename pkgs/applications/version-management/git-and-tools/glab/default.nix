{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glab";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "profclems";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-naCCJ9s63UPDxRWbVjVikXtGUlM4Lp7vyDHlESEtXeI=";
  };

  vendorSha256 = "sha256-rciT4UcsLu/vI0PqdTlMjbYXVumzo3ASsopkgiHGM60=";

  ldflags = [
    "-X main.version=${version}"
  ];

  preCheck = ''
    # failed to read configuration:  mkdir /homeless-shelter: permission denied
    export HOME=$TMPDIR
  '';

  subPackages = [ "cmd/glab" ];

  meta = with lib; {
    description = "An open-source GitLab command line tool";
    license = licenses.mit;
    homepage = "https://glab.readthedocs.io/";
    maintainers = with maintainers; [ freezeboy ];
  };
}
