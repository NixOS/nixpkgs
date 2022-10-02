{ lib, buildGoModule, fetchFromGitHub, testers, spicetify-cli }:

buildGoModule rec {
  pname = "spicetify-cli";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iaaf5ZHaHSEkQdxqZtsc6K/3+x6gAfvgQoWWYWcFeV4=";
  };

  vendorSha256 = "sha256-zYIbtcDM9iYSRHagvI9D284Y7w0ZxG4Ba1p4jqmQyng=";

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
