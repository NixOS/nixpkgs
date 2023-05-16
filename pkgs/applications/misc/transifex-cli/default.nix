{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "transifex-cli";
<<<<<<< HEAD
  version = "1.6.10";
=======
  version = "1.6.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "transifex";
    repo = "cli";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-76nmlZFLon9EquM7tQ/PReM1rxkzh7x1rNdaP3n4KKg=";
  };

  vendorHash = "sha256-rcimaHr3fFeHSjZXw1w23cKISCT+9t8SgtPnY/uYGAU=";
=======
    sha256 = "sha256-5166P44HSRKQ0pCh1BCPd1ZUryh/IBDumcnLYA+CSBY=";
  };

  vendorSha256 = "sha256-rcimaHr3fFeHSjZXw1w23cKISCT+9t8SgtPnY/uYGAU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s" "-w" "-X 'github.com/transifex/cli/internal/txlib.Version=${version}'"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/tx
  '';

  # Tests contain network calls
  doCheck = false;

  meta = with lib; {
    description = "The Transifex command-line client";
    homepage = "https://github.com/transifex/transifex-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ thornycrackers ];
  };
}
