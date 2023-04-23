{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ircdog";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "goshuirc";
    repo = "ircdog";
    rev = "refs/tags/v${version}";
    hash = "sha256-uqqgXmEpGEJHnd1mtgpp13jFhKP5fbhE5wtcZNZL8t4=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "ircdog is a simple wrapper over the raw IRC protocol that can respond to pings, and interprets formatting codes";
    homepage = "https://github.com/ergochat/ircdog";
    changelog = "https://github.com/ergochat/ircdog/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ hexa ];
  };
}


