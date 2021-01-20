{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "spicetify-cli";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "khanhas";
    repo = pname;
    rev = "v${version}";
    sha256 = "08rnwj7ggh114n3mhhm8hb8fm1njgb4j6vba3hynp8x1c2ngidff";
  };

  vendorSha256 = "0k06c3jw5z8rw8nk4qf794kyfipylmz6x6l126a2snvwi0lmc601";

  # used at runtime, but not installed by default
  postInstall = ''
    cp -r ${src}/jsHelper $out/bin/jsHelper
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/spicetify-cli --help > /dev/null
  '';

  meta = with lib; {
    description = "Command-line tool to customize Spotify client";
    homepage = "https://github.com/khanhas/spicetify-cli/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jonringer ];
  };
}
