{ lib
, buildGoModule
, fetchFromGitHub
, testers
, tf-summarize
}:

buildGoModule rec {
  pname = "tf-summarize";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "dineshba";
    repo = "tf-summarize";
    rev = "v${version}";
    sha256 = "0c6fcz0n22mq8bqr82h9lfxx4n1bk9gjlc7d131lpf14yiacih3p";
  };

  vendorSha256 = "cnybdZth7qlP2BHK8uvLCoqJtggMIkvaL2+YugiUZRE=";
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = tf-summarize;
    command = "tf-summarize -v";
    inherit version;
  };

  meta = with lib; {
    description = "Command-line utility to print the summary of the terraform plan";
    homepage = "https://github.com/dineshba/tf-summarize";
    license = licenses.mit;
    maintainers = with maintainers; [ pjrm ];
  };
}
