{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ircdog";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "goshuirc";
    repo = "ircdog";
    rev = "refs/tags/v${version}";
    hash = "sha256-rV9IBa30v1T3Zw/av8nfmX9Bg20FPAGdJkMn17r8rYw=";
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


