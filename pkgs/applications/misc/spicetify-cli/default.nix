{ lib, buildGoModule, fetchFromGitHub, testers, spicetify-cli }:

buildGoModule rec {
  pname = "spicetify-cli";
  version = "2.27.1";

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "spicetify-cli";
    rev = "v${version}";
    hash = "sha256-Z+paJAuzUnCdCSx2UHg1HV14vDo3jWsyUrcbEnvqTm0=";
  };

  vendorHash = "sha256-H2kSTsYiD9HResHes+7YxUyNcjtM0SLpDPUC0Y518VM=";

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
    maintainers = with maintainers; [ jonringer mdarocha ];
    mainProgram = "spicetify-cli";
  };
}
