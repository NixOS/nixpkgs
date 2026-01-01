{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule {
  pname = "lnch";
  version = "0-unstable-2021-08-15";

  src = fetchFromGitHub {
    owner = "oem";
    repo = "lnch";
    rev = "56b5e256b46c002821bef3b9c1b6f68b9dbb4207";
    sha256 = "sha256-Iro/FjPFMqulcK90MbludnOXkMEHW0QSCoQRL01/LDE";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/oem/lnch";
    description = "Launches a process and moves it out of the process group";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://github.com/oem/lnch";
    description = "Launches a process and moves it out of the process group";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "lnch";
  };
}
