{ lib, buildGoModule, fetchFromGitHub, testers, spicetify-cli }:

buildGoModule rec {
  pname = "spicetify-cli";
  version = "2.33.1";

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "spicetify-cli";
    rev = "v${version}";
    hash = "sha256-nKbdwgxHiI1N2REEI7WrPf54uy4Nm1XU0g5hEjYriEY=";
  };

  vendorHash = "sha256-9rYShpUVI3KSY6UgGmoXo899NkUezkAAkTgFPdq094E=";

  ldflags = [
    "-s -w"
    "-X 'main.version=${version}'"
  ];

  # used at runtime, but not installed by default
  postInstall = ''
    cp -r ${src}/jsHelper $out/bin/jsHelper
    cp -r ${src}/CustomApps $out/bin/CustomApps
    cp -r ${src}/Extensions $out/bin/Extensions
    cp -r ${src}/Themes $out/bin/Themes
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
    maintainers = with maintainers; [ jonringer mdarocha ];
    mainProgram = "spicetify-cli";
  };
}
