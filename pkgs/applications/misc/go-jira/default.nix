{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-jira";
  version = "1.0.24";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "go-jira";
    repo = "jira";
    sha256 = "1qpimh39hsg75mb32hlvxmd7jj5b0cmhdkqz3dizfcnidllr3grd";
  };

  vendorSha256 = "18jwxnkv94lsxfv57ga519knxm077cc8chp5c992ipk58a04nv18";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Simple command line client for Atlassian's Jira service written in Go";
    homepage = "https://github.com/go-jira/jira";
    license = licenses.asl20;
    maintainers = with maintainers; [ carlosdagos timstott ];
  };
}
