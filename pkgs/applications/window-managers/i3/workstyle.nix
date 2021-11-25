{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "workstyle";
  version = "unstable-2021-05-09";

  src = fetchFromGitHub {
    owner = "pierrechevalier83";
    repo = pname;
    rev = "f2023750d802259ab3ee7d7d1762631ec157a0b1";
    sha256 = "04xds691sw4pi2nq8xvdhn0312wwia60gkd8b1bjqy11zrqbivbx";
  };

  cargoSha256 = "0xwv8spr96z4aimjlr15bhwl6i3zqp7jr45d9zr3sbi9d8dbdja2";

  doCheck = false; # No tests

  meta = with lib; {
    description = "Sway workspaces with style";
    homepage = "https://github.com/pierrechevalier83/workstyle";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
