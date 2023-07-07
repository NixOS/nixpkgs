{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ircdog";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "goshuirc";
    repo = "ircdog";
    rev = "refs/tags/v${version}";
    hash = "sha256-nXXSHNQp+yFfgY/VPqaMLM6lv4oYE97rdgHYW+0+L9g=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "ircdog is a simple wrapper over the raw IRC protocol that can respond to pings, and interprets formatting codes";
    homepage = "https://github.com/ergochat/ircdog";
    changelog = "https://github.com/ergochat/ircdog/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ hexa ];
  };
}


