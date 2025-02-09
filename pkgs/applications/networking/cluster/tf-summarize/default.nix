{ lib
, buildGoModule
, fetchFromGitHub
, testers
, tf-summarize
}:

buildGoModule rec {
  pname = "tf-summarize";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "dineshba";
    repo = "tf-summarize";
    rev = "v${version}";
    hash = "sha256-8TRX7gAbBlCIOHbwRIVoke2WBSgwLx9121Fg5h0LPF0=";
  };

  vendorHash = "sha256-YdfZt8SHBJHk5VUC8Em97EzX79EV4hxvo0B05npBA2U=";

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
