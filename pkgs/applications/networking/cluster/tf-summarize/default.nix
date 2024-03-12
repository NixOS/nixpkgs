{ lib
, buildGoModule
, fetchFromGitHub
, testers
, tf-summarize
}:

buildGoModule rec {
  pname = "tf-summarize";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "dineshba";
    repo = "tf-summarize";
    rev = "v${version}";
    hash = "sha256-lG30+Ihc8G5kHUskDNuQivNYGioiZxWw/1C1D/pm62U=";
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
    homepage = "https://github.com/dineshba/tf-summarize";
    license = licenses.mit;
    maintainers = with maintainers; [ pjrm ];
  };
}
