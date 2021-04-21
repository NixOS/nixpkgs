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

  buildPhase = ''
    VERSION=${version} make build
  '';

  installPhase = ''
    install -Dm0755 git-chglog $out/bin/git-chglog
    ./git-chglog --version
  '';

  meta = with lib; {
    description = "CHANGELOG generator implemented in Go (Golang)";
    license = licenses.mit;
    maintainers = with maintainers; [ ldenefle ];
  };
}

