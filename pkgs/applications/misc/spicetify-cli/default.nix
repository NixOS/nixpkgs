{ lib, buildGoModule, fetchFromGitHub, testers, spicetify-cli }:

buildGoModule rec {
  pname = "spicetify-cli";
  version = "2.17.1";

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hgLJVD3JEehQjPO5T54xk5JxbcVyiBu4PXV+EdOczag=";
  };

  vendorHash = "sha256-mAtwbYuzkHUqG4fr2JffcM8PmBsBrnHWyl4DvVzfJCw=";

  ldflags = [
    "-s -w"
    "-X 'main.version=${version}'"
  ];

  # used at runtime, but not installed by default
  postInstall = ''
    cp -r ${src}/jsHelper $out/bin/jsHelper
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/spicetify-cli --help > /dev/null
  '';

  passthru.tests.version = testers.testVersion {
    package = spicetify-cli;
    command = "spicetify-cli -v";
  };

  meta = with lib; {
    description = "Command-line tool to customize Spotify client";
    homepage = "https://github.com/spicetify/spicetify-cli/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jonringer ];
  };
}
