{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cdncheck";
<<<<<<< HEAD
  version = "1.2.16";
=======
  version = "1.2.11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cdncheck";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-wwBVFADPjN1KydWDsZO5tea0aRJlyIU6zTEDXLXm6P8=";
  };

  vendorHash = "sha256-0aaneqeIlp+vBRdR5REOq3JOvFS0DOSH6RBo+OmaytU=";
=======
    hash = "sha256-8EBOvwYsanLkz1DbBwprrP8zZrMX1a/od517qubwzBk=";
  };

  vendorHash = "sha256-tJXfJHEZ1KysnJIkVX+UxP3CnTCzlZtsTlVbCSCNeg8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "cmd/cdncheck/" ];

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    # Tests require network access
    substituteInPlace other_test.go \
      --replace-fail "TestCheckDomainWithFallback" "SkipTestCheckDomainWithFallback" \
      --replace-fail "TestCheckDNSResponse" "SkipTestCheckDNSResponse"
  '';

  meta = {
    description = "Tool to detect various technology for a given IP address";
    homepage = "https://github.com/projectdiscovery/cdncheck";
    changelog = "https://github.com/projectdiscovery/cdncheck/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cdncheck";
  };
}
