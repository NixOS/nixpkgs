{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fq,
  testers,
}:

buildGoModule rec {
  pname = "fq";
<<<<<<< HEAD
  version = "0.16.0";
=======
  version = "0.15.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-b28zncqz0B1YIXHCjklAkVbIdXxC36bqIwJ4VrrCe18=";
  };

  vendorHash = "sha256-bF3N+cPJAxAEFmr2Gl3xdKLtv7yLkxze19NgDFWaBn8=";
=======
    hash = "sha256-7AWugaSK9JFkWPKjjtgTZZ37rXUYYco2XXY4JEA7sSk=";
  };

  vendorHash = "sha256-87jMUtFy/BNUqsfzqyFtk3EB5i71O2zeFYvErV+HBAA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "." ];

  passthru.tests = testers.testVersion { package = fq; };

<<<<<<< HEAD
  meta = {
    description = "jq for binary formats";
    mainProgram = "fq";
    homepage = "https://github.com/wader/fq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
=======
  meta = with lib; {
    description = "jq for binary formats";
    mainProgram = "fq";
    homepage = "https://github.com/wader/fq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
