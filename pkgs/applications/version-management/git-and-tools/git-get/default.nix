{ lib, fetchFromGitHub, buildGoModule, pkgs }:

buildGoModule rec{
  pname = "git-get";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "grdl";
    repo = "git-get";
    rev = "v${version}";
    sha256 = "BantFytvr+grCZjUME9Hm3k+8c+NcNYnKuagrUrQOww=";
  };
  vendorSha256 = "C+XOjMDMFneKJNeBh0KWPx8yM7XiiIpTlc2daSfhZhY=";

  doCheck = true;
  checkInputs = [ pkgs.git ];
  preCheck = ''
    export HOME=`mktemp -d`
    git config --global user.email "user@example.com"
    git config --global user.user "user"
    # this test tries to access /root
    rm pkg/git/finder_test.go
  '';

  ldflags = [
    "-s"
    "-w"
    "-X git-get/pkg/cfg.version=${version}"
    "-X git-get/pkg/cfg.commit=bdfb8db73ebff9f43f4d2b34bae65d7d041cd92d"
    "-X git-get/pkg/cfg.date=2022-10-28"
  ];

  postInstall = ''
    mv $out/bin/list $out/bin/git-list
    mv $out/bin/get $out/bin/git-get
  '';

  meta = with lib; {
    description = "A better way to clone, organize and manage multiple git repositories";
    homepage = "https://github.com/grdl/git-get";
    license = licenses.mit;
    maintainers = with maintainers; [ bpaulin ];
  };
}
