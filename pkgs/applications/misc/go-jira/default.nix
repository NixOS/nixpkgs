{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-jira";
  version = "1.0.27";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "go-jira";
    repo = "jira";
    sha256 = "1sw56aqghfxh88mfchf0nvqld0x7w22jfwx13pd24slxv1iag1nb";
  };

  vendorSha256 = "0d64gkkzfm6hbgqaibj26fpaqnjs50p1675ycrshdhn6blb5mbxg";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Simple command line client for Atlassian's Jira service written in Go";
    homepage = "https://github.com/go-jira/jira";
    license = licenses.asl20;
    maintainers = with maintainers; [ carlosdagos timstott ];
  };
}
