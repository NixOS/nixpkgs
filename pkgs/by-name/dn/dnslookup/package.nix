{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dnslookup";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "ameshkov";
    repo = "dnslookup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jN1JBqCZPoLbdododPRRRGfZugyesWb1Xt+np/xXK6U=";
  };

  vendorHash = "sha256-FFVxqnFwYsoPt2wCmMpxxe+YkSg6ry71XbFd463uXn4=";

  meta = {
    changelog = "https://github.com/ameshkov/dnslookup/releases/tag/v${finalAttrs.version}";
    description = "Simple command line utility to make DNS lookups to the specified server";
    homepage = "https://github.com/ameshkov/dnslookup";
    license = lib.licenses.mit;
    mainProgram = "dnslookup";
    maintainers = [ lib.maintainers.philiptaron ];
  };
})
