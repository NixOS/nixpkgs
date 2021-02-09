{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "spicetify-cli";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "khanhas";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Gkq19OlX6ci2i5mno77O/v3VfUkv6FRQFcH98qaUuXs=";
  };

  vendorSha256 = "sha256-ARhWKYh8Wy2UEYGabn6l/kbnJ0nHYTIt4hn9wuVgBkw=";

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
