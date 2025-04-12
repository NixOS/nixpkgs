{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cloudfox";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = "cloudfox";
    rev = "refs/tags/v${version}";
    hash = "sha256-YLZSrBAEf0SXECAdnF2CQAlEd15DJ1Iv+x+RebM5tw4=";
  };

  vendorHash = "sha256-MQ1yoJjAWNx95Eafcarp/JNYq06xu9P05sF2QTW03NY=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Some tests are failing because of wrong filename/path
  doCheck = false;

  meta = with lib; {
    description = "Tool for situational awareness of cloud penetration tests";
    homepage = "https://github.com/BishopFox/cloudfox";
    changelog = "https://github.com/BishopFox/cloudfox/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "cloudfox";
  };
}
