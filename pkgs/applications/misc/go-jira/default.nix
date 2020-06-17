{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-jira";
  version = "1.0.23";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "go-jira";
    repo = "jira";
    sha256 = "0qk5ifjxkqisvgv066rw8xj2zszc9mhc0by4338xjd7ng10jkk7b";
  };

  vendorSha256 = "18jwxnkv94lsxfv57ga519knxm077cc8chp5c992ipk58a04nv18";

  meta = with stdenv.lib; {
    description = "Simple command line client for Atlassian's Jira service written in Go";
    homepage = "https://github.com/go-jira/jira";
    license = licenses.asl20;
    maintainers = with maintainers; [ carlosdagos timstott ];
  };
}
