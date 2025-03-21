{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "7.8.1";

  src = fetchFromGitHub {
    repo = pname;
    owner = "oauth2-proxy";
    sha256 = "sha256-NU9/BLyTEWGqt9SJNbvF4kSG/op8TEpYV2A24/V29PM=";
    rev = "v${version}";
  };

  patches = [
    ./fix-tests-go-1.24.diff
  ];

  vendorHash = "sha256-t/SJjh9bcsIevr3S0ysDlvtaIGzkks+qvfXF5/SEidE=";

  # Taken from https://github.com/oauth2-proxy/oauth2-proxy/blob/master/Makefile
  ldflags = [ "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "Reverse proxy that provides authentication with Google, Github, or other providers";
    homepage = "https://github.com/oauth2-proxy/oauth2-proxy/";
    license = licenses.mit;
    maintainers = teams.serokell.members;
    mainProgram = "oauth2-proxy";
  };
}
