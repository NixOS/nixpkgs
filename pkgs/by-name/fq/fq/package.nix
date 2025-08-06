{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fq,
  testers,
}:

buildGoModule rec {
  pname = "fq";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
    hash = "sha256-7AWugaSK9JFkWPKjjtgTZZ37rXUYYco2XXY4JEA7sSk=";
  };

  vendorHash = "sha256-87jMUtFy/BNUqsfzqyFtk3EB5i71O2zeFYvErV+HBAA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "." ];

  passthru.tests = testers.testVersion { package = fq; };

  meta = with lib; {
    description = "jq for binary formats";
    mainProgram = "fq";
    homepage = "https://github.com/wader/fq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
