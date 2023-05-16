{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopacked";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "gopacked";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-PpOLLqgUQf09grZlJ7bXTxAowzDusmVN8PHfaGlGGQ8=";
  };

  vendorHash = "sha256-ooxVXNbqoh3XX3yFemAyqISNZ+PC8WJUe+ch2OnIdDo=";
=======
    sha256 = "03qr8rlnipziy16nbcpf631jh42gsyv2frdnh8yzsh8lm0p8p4ry";
  };

  vendorSha256 = "0fklr3lxh8g7gda65wf2wdkqv15869h7m1bwbzbiv8pasrf5b352";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  meta = with lib; {
    description = "A simple text-based Minecraft modpack manager";
    license = licenses.agpl3;
    homepage = src.meta.homepage;
    maintainers = with maintainers; [ ];
  };
}
