{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "git-chglog";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "git-chglog";
    repo = "git-chglog";
    rev = "v${version}";
    sha256 = "124bqywkj37gv61fswgrg528bf3rjqms1664x22lkn0sqh22zyv1";
  };

  vendorSha256 = "09zjypmcc3ra7sw81q1pbbrlpxxp4k00p1cfkrrih8wvb25z89h5";

  buildFlagsArray = [ "-ldflags= -s -w -X=main.Version=v${version}" ];

  subPackages = [ "cmd/git-chglog" ];

  meta = with lib; {
    description = "CHANGELOG generator implemented in Go (Golang)";
    homepage = "https://github.com/git-chglog/git-chglog";
    license = licenses.mit;
    maintainers = with maintainers; [ ldenefle ];
  };
}

