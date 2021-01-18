{ stdenv, lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "twtxt";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jointwt";
    repo = pname;
    rev = version;
    sha256 = "15jhfnhpk34nmad04f7xz1w041dba8cn17hq46p9n5sarjgkjiiw";
  };

  vendorSha256 = "1lnf8wd2rv9d292rp8jndfdg0rjs6gfw0yg49l9spw4yzifnd7f7";

  subPackages = [ "cmd/twt" "cmd/twtd" ];

  meta = with lib; {
    description = "Self-hosted, Twitter-like decentralised microblogging platform";
    homepage = "https://github.com/jointwt/twtxt";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
