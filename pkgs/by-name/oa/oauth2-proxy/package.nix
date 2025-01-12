{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "7.7.1";

  src = fetchFromGitHub {
    repo = pname;
    owner = "oauth2-proxy";
    sha256 = "sha256-SKewLChFKPx1aEKYRqw6IxjLdpKehqcnPT6oQoP8uaU=";
    rev = "v${version}";
  };

  vendorHash = "sha256-MBsvTYJ8G/WeTp8wQJhBDrKjJX/7Utve4mh1yXbD6uc=";

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
