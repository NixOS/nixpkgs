{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pachyderm";
<<<<<<< HEAD
  version = "2.7.0";
=======
  version = "2.5.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pachyderm";
    repo = "pachyderm";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-OA6NY8hI/Aw6vdtDfN1cRXdsLLfxW5ECg5tobPZB66Y=";
  };

  vendorHash = "sha256-q8Cx+J5BjMvO5wuvH5Tc5Oa9rjW7vXvS4DhSVv/E3E4=";
=======
    hash = "sha256-RaMOn5Cb98wKI9w0+kVUCMiySKGuudXHsi+EXFIm3Zc=";
  };

  vendorHash = "sha256-XmIPifozTYd1rV2wm0dU0GPvg/+HFoSLGHB6DDrkzVc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "src/server/cmd/pachctl" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pachyderm/pachyderm/v${lib.versions.major version}/src/version.AppVersion=${version}"
  ];

  meta = with lib; {
    description = "Containerized Data Analytics";
    homepage = "https://www.pachyderm.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ offline ];
    mainProgram = "pachctl";
  };
}
