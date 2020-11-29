{ stdenv, fetchFromGitLab, git, buildGoModule }:

buildGoModule rec {
  pname = "gitlab-workhorse";

  version = "8.54.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "0fz00sl9q4d3vbslh7y9nsnhjshgfg0x7mv7b7a9sc3mxmabp7gz";
  };

  vendorSha256 = "0wi6vj9phwh0bsdk2lrgq807nb90iivlm0bkdjkim06jq068mizj";
  buildInputs = [ git ];
  buildFlagsArray = "-ldflags=-X main.Version=${version}";
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin talyz ];
    license = licenses.mit;
  };
}
