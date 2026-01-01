{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dnslookup";
<<<<<<< HEAD
  version = "1.11.2";
=======
  version = "1.11.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ameshkov";
    repo = "dnslookup";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-jN1JBqCZPoLbdododPRRRGfZugyesWb1Xt+np/xXK6U=";
  };

  vendorHash = "sha256-FFVxqnFwYsoPt2wCmMpxxe+YkSg6ry71XbFd463uXn4=";
=======
    hash = "sha256-zgEW4ANIlwF0f6YqTQicGhGgLc9RaL7Xy0wg/ICzOK4=";
  };

  vendorHash = "sha256-pdnKYsXBw/IjakUyQym4thnO3gXgvwNm80Ha8AUVt54=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    changelog = "https://github.com/ameshkov/dnslookup/releases/tag/v${version}";
    description = "Simple command line utility to make DNS lookups to the specified server";
    homepage = "https://github.com/ameshkov/dnslookup";
    license = lib.licenses.mit;
    mainProgram = "dnslookup";
    maintainers = [ lib.maintainers.philiptaron ];
  };
}
