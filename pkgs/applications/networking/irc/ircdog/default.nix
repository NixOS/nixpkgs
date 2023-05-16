{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ircdog";
<<<<<<< HEAD
  version = "0.5.1";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "goshuirc";
    repo = "ircdog";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-nXXSHNQp+yFfgY/VPqaMLM6lv4oYE97rdgHYW+0+L9g=";
  };

  vendorHash = null;
=======
    hash = "sha256-uqqgXmEpGEJHnd1mtgpp13jFhKP5fbhE5wtcZNZL8t4=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "ircdog is a simple wrapper over the raw IRC protocol that can respond to pings, and interprets formatting codes";
    homepage = "https://github.com/ergochat/ircdog";
    changelog = "https://github.com/ergochat/ircdog/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ hexa ];
  };
}


