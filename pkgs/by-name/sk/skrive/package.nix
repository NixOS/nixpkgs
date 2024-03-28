{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
}:

buildGoModule rec {
  pname = "skrive";
  version = "0.9.0";
  src = fetchFromGitHub {
    owner = "VanuPhantom";
    repo = "skrive";
    rev = "refs/tags/v${version}";
    hash = "sha256-NB1L685j881G0AEjx9gevTd1T8jkz8/IXUay2fPQ7Xs=";
  };

  vendorHash = "sha256-gPHt9yggrxVONOdC2/YcC5wHhI/mottc2Pq7IVGmE4I=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv skrive.1.man skrive.1
    installManPage skrive.1
  '';

  meta = with lib; {
    description = "Secure and sleek dosage logging for the terminal";
    homepage = "https://github.com/VanuPhantom/skrive";
    changelog = "https://github.com/VanuPhantom/skrive/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ freyacodes ];
    mainProgram = "skrive";
    platforms = platforms.all;
  };
}
