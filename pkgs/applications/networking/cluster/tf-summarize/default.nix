{ lib
, buildGoModule
, fetchFromGitHub
, testers
, tf-summarize
}:

buildGoModule rec {
  pname = "tf-summarize";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "dineshba";
    repo = "tf-summarize";
    rev = "v${version}";
    hash = "sha256-OmGJgy36Jv7/kyGg2y1cNS1r6n1C/plfC0s6q08Wox4=";
  };

  vendorHash = "sha256-nfontEgMj2qPbrM35iR7b65qrkWHCMY1v944iYdNLG8=";

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
    mainProgram = "tf-summarize";
    homepage = "https://github.com/dineshba/tf-summarize";
    license = licenses.mit;
    maintainers = with maintainers; [ pjrm ];
  };
}
