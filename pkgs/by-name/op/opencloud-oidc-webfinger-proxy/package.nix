{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule rec {
  pname = "opencloud-oidc-webfinger-proxy";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "2bros-group";
    repo = "opencloud-oidc-webfinger-proxy";
    rev = "v${version}";
    hash = "sha256-dI8rm/7Xly0cDjRYxKv6l6b2003YMcwz0k77KxBu/AU=";
  };

  # Generate a minimal go.mod before building because upstream does not provide one.
  preBuild = ''
    if [ ! -f go.mod ]; then
      echo "module github.com/2bros-group/opencloud-oidc-webfinger-proxy" > go.mod
      go mod tidy
    fi
  '';

  vendorHash = null;

  nativeBuildInputs = [ makeWrapper ];

  meta = {
    description = "A lightweight Go-based reverse proxy that dynamically rewrites href fields in WebFinger responses for OpenID Connect (OIDC) clients.";
    homepage = "https://github.com/2bros-group/opencloud-oidc-webfinger-proxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hajoha ];
    platforms = lib.platforms.all;
  };
}
