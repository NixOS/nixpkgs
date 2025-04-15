{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "7.8.2";

  src = fetchFromGitHub {
    repo = pname;
    owner = "oauth2-proxy";
    sha256 = "sha256-RT0uoNRFFZ3BNSwukGZ0P70jtDYAwUI1m+pzFyHnNjU=";
    rev = "v${version}";
  };

  patches = [
    ./fix-tests-go-1.24.diff
  ];

  vendorHash = "sha256-5wkwXHLFEhr5H1vpw4T659456KqgBeMZ8OAnYYU5Ln0=";

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
