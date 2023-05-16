{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
<<<<<<< HEAD
  version = "0.12.6";
=======
  version = "0.12.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-RtUHJIMbodICEDIhjH/QZlAS7dxBsL/uNYA2IoObAg0=";
  };

  vendorHash = "sha256-V5azvQ8vMkgF2Myt6h5Gw09b+Xwg1XLyTImG52qQ+20=";
=======
    sha256 = "sha256-lTjpvh0bl4Fk+d3mcDvVQY3Ef6UYE23qoS60nltVcsU=";
  };

  vendorSha256 = "sha256-TNxAtx+fT6CEpa2g/tNl9sCwt3kAmNq7G870TPt2MQ4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    changelog = "https://github.com/charmbracelet/charm/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
