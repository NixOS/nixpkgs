{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
<<<<<<< HEAD
  version = "0.5.0";
=======
  version = "0.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-dEAlOKjNXL7zqlll6lqGmbopjdplDR3ewMMNu9TMsmw=";
  };

  vendorHash = "sha256-WZsm2wiKedMP0miwnzhnSrF7Qw+jqd8dnpcehlsdMCA=";
=======
    sha256 = "sha256-4crBl0aQFsSB1D3iuAVcwcet8KSUB3/tUi1kD1VmpAI=";
  };

  vendorHash = "sha256-qFupm0ymDw9neAu6Xl3fQ/mMWn9f40Vdf7uOLOBkcaE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # No tests
  doCheck = false;
  doInstallCheck = true;
  installCheckPhase = ''
    export HOME=$(mktemp -d)
    echo checking the version print of pdfcpu
    $out/bin/pdfcpu version | grep ${version}
  '';

  subPackages = [ "cmd/pdfcpu" ];

  meta = with lib; {
    description = "A PDF processor written in Go";
    homepage = "https://pdfcpu.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
