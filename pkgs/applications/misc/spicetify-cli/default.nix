{ lib, buildGoModule, fetchFromGitHub, testers, spicetify-cli }:

buildGoModule rec {
  pname = "spicetify-cli";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-262tnSKX6M9ggm4JIs0pANeq2JSNYzKkTN8awpqLyMM=";
  };

  vendorSha256 = "sha256-E2Q+mXojMb8E0zSnaCOl9xp5QLeYcuTXjhcp3Hc8gH4=";

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
