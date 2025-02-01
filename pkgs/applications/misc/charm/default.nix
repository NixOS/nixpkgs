{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 = "sha256-RtUHJIMbodICEDIhjH/QZlAS7dxBsL/uNYA2IoObAg0=";
  };

  vendorHash = "sha256-V5azvQ8vMkgF2Myt6h5Gw09b+Xwg1XLyTImG52qQ+20=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    changelog = "https://github.com/charmbracelet/charm/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
    mainProgram = "charm";
  };
}
