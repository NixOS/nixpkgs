{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "base16-universal-manager";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "pinpox";
    repo = "base16-universal-manager";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-9KflJ863j0VeOyu6j6O28VafetRrM8FW818qCvqhaoY=";
  };

  vendorHash = "sha256-U28OJ5heeiaj3aGAhR6eAXzfvFMehAUcHzyFkZBRK6c=";
=======
    sha256 = "11kal7x0lajzydbc2cvbsix9ympinsiqzfib7dg4b3xprqkyb9zl";
  };

  vendorSha256 = "19rba689319w3wf0b10yafydyz01kqg8b051vnijcyjyk0khwvsk";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A universal manager to set base16 themes for any supported application";
    homepage = "https://github.com/pinpox/base16-universal-manager";
    license = licenses.mit;
    maintainers = with maintainers; [ jo1gi ];
  };
}
