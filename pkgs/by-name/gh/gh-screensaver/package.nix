{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gh-screensaver";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "vilmibm";
    repo = "gh-screensaver";
    rev = "v${version}";
    hash = "sha256-MqwaqXGP4E+46vpgftZ9bttmMyENuojBnS6bWacmYLE=";
  };

  vendorHash = "sha256-o9B6Q07GP/CFekG3av01boZA7FdZg4x8CsLC3lwhn2A=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "gh extension with animated terminal screensavers";
    homepage = "https://github.com/vilmibm/gh-screensaver";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
    mainProgram = "gh-screensaver";
  };
}
