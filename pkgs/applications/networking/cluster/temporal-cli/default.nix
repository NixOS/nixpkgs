{ lib, fetchFromGitHub, fetchpatch, buildGoModule, testers, temporal-cli }:

buildGoModule rec {
  pname = "temporal-cli";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "tctl";
    rev = "v${version}";
    sha256 = "sha256-WNdu/62/VmxTmzAvzx3zIlcAAlEmpN0yKzQOSUtrL8s=";
  };

  patches = [
    # Fix tests
    (fetchpatch {
      name = "fix-tests.patch";
      url = "https://github.com/temporalio/tctl/pull/203/commits/2b113da137a3a925e8fbd7c18bdaaefc31397db4.patch";
      sha256 = "sha256-HFPwbmLZ2uPHzaHvYoB4MTZvMVyzvUKggA76/bh50DQ=";
    })
  ];

  vendorSha256 = "sha256-WF3T+HNisfR0JoKkHCC77kmHmsGZ9NfQ7UCwOmpCG/o=";

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = temporal-cli;
  };

  meta = with lib; {
    description = "Temporal CLI";
    homepage = "https://temporal.io";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "tctl";
  };
}
