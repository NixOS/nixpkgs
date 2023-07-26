{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage {
  pname = "i3-cycle-focus";
  version = "unstable-2021-09-27";

  src = fetchFromGitHub {
    owner = "TheDoctor314";
    repo = "i3-cycle-focus";
    rev = "d94f22e4b8502de4ed846a211fa0c8418b3e3e89";
    hash = "sha256-caZKvxOqoYgPs+Zjltj8K0/ospjkLnA4kh0rsTjeU3Y=";
  };

  cargoHash = "sha256-9glaxThm/ovgvUWCyrycS/Oe5t8iN5P38fF5vO5awQE=";

  meta = with lib; {
    description = "A simple tool to cyclically switch between the windows on the active workspace";
    homepage = "https://github.com/TheDoctor314/i3-cycle-focus";
    license = licenses.unlicense;
    maintainers = with maintainers; [ GaetanLepage ];
    platforms = platforms.linux;
  };
}
