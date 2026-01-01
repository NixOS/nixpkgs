{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "olm";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.1.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "olm";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-HwmWwGs62Dy/65HTgApuXLv4YRrFzi37A4JoL7vdLdo=";
  };

  vendorHash = "sha256-hLnoQof899zLnjbHrzvW2Y3Jj6fegxCVCRnz3XYKCeQ=";
=======
    hash = "sha256-zUqKfrtNx6XmMSJHAfc1/ht3nPR5xy1BIijMT6u2+s8=";
  };

  vendorHash = "sha256-mY/JE26/nug9cg4hPp7hgIoKf8ORnVlDDzVw3ioBj2s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  meta = {
    description = "Tunneling client for Pangolin";
    homepage = "https://github.com/fosrl/olm";
    changelog = "https://github.com/fosrl/olm/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      sigmasquadron
<<<<<<< HEAD
      water-sucks
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
    mainProgram = "olm";
  };
}
