{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "7.9.0";

  src = fetchFromGitHub {
    repo = "oauth2-proxy";
    owner = "oauth2-proxy";
    sha256 = "sha256-ykC29q7/rTv7POGETMiypj9CQYdYVo7rjT5B+3nfj/U=";
    rev = "v${version}";
  };

  patches = [
    ./fix-tests-go-1.24.diff
  ];

  vendorHash = "sha256-KIu/NSKaXLutlY8757haAlsyuHUZjkDZ6D10lJ08uCM=";

  # Taken from https://github.com/oauth2-proxy/oauth2-proxy/blob/master/Makefile
  ldflags = [ "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "Reverse proxy that provides authentication with Google, Github, or other providers";
    homepage = "https://github.com/oauth2-proxy/oauth2-proxy/";
    license = licenses.mit;
    teams = [ teams.serokell ];
    mainProgram = "oauth2-proxy";
  };
}
