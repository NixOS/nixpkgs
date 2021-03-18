{ lib, fetchFromGitLab, git, buildGoModule }:

buildGoModule rec {
  pname = "gitlab-workhorse";

  version = "8.63.2";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "1vjk7r7228p2gblx9nmqiz70ckbllg1p3bwkyfd4m49jhp13hryi";
  };

  vendorSha256 = "0hc02nxw5jp1mhpjcx1f2a2dfaq7ji4qkf5g7lbpd1rzhqwp6zsz";
  buildInputs = [ git ];
  buildFlagsArray = "-ldflags=-X main.Version=${version}";
  doCheck = false;

  meta = with lib; {
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin talyz ];
    license = licenses.mit;
  };
}
