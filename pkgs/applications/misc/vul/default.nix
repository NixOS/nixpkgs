{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "vul";
  version = "unstable-2022-07-02";

  src = fetchFromGitHub {
    owner = "LukeSmithxyz";
    repo = pname;
    rev = "97efaedb79c9de62b6a19b04649fd8c00b85973f";
    sha256 = "sha256-NwRUx7WVvexrCdPtckq4Szf5ISy7NVBHX8uAsRtbE+0=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Latin Vulgate Bible on the Command Line";
    homepage = "https://github.com/LukeSmithxyz/vul";
    license = licenses.publicDomain;
    maintainers = [ maintainers.j0hax maintainers.cafkafk ];
    mainProgram = "vul";
  };
}
