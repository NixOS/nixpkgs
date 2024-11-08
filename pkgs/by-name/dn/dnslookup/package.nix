{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dnslookup";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "ameshkov";
    repo = "dnslookup";
    rev = "refs/tags/v${version}";
    hash = "sha256-zgEW4ANIlwF0f6YqTQicGhGgLc9RaL7Xy0wg/ICzOK4=";
  };

  vendorHash = "sha256-pdnKYsXBw/IjakUyQym4thnO3gXgvwNm80Ha8AUVt54=";

  meta = {
    changelog = "https://github.com/ameshkov/dnslookup/releases/tag/v${version}";
    description = "Simple command line utility to make DNS lookups to the specified server";
    homepage = "https://github.com/ameshkov/dnslookup";
    license = lib.licenses.mit;
    mainProgram = "dnslookup";
    maintainers = [ lib.maintainers.philiptaron ];
  };
}
