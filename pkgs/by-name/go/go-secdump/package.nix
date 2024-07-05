{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-secdump";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "jfjallid";
    repo = "go-secdump";
    rev = "refs/tags/${version}";
    hash = "sha256-mb44v79BH9wW8+b1Le0lyVtl5iHIEzGvgVzaf0zEG20=";
  };

  vendorHash = "sha256-xgvT+RnaTzkVql7js/Mb5vZM5BV+B3OJbCTfDWDmt7c=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to remotely dump secrets from the Windows registry";
    homepage = "https://github.com/jfjallid/go-secdump";
    changelog = "https://github.com/jfjallid/go-secdump/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "go-secdump";
  };
}
