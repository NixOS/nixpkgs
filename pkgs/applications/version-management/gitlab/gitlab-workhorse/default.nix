{ stdenv, fetchFromGitLab, git, buildGoModule }:

buildGoModule rec {
  pname = "gitlab-workhorse";

  version = "8.54.2";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "1rg1l2d95p9zgd52d96s18l5xidds2l3gz4hyb5hjyxf59027m22";
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
