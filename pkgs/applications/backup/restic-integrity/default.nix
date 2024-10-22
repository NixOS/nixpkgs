{ lib
, rustPlatform
, fetchFromGitea
}:

rustPlatform.buildRustPackage rec {
  pname = "restic-integrity";
  version = "1.3.1";

  src = fetchFromGitea {
    domain = "git.nwex.de";
    owner = "networkException";
    repo = "restic-integrity";
    rev = version;
    hash = "sha256-5F2nFSyqrT4JEzUb1NVk0g2LqgwRix3rfflXJ3pttvo=";
  };

  cargoHash = "sha256-97M7dqgTzl2ysegavwzf6xtYKum/s9cq4vgaIQR7IA0=";

  meta = with lib; {
    description = "CLI tool to check the integrity of a restic repository without unlocking it";
    homepage = "https://git.nwex.de/networkException/restic-integrity";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ networkexception ];
    mainProgram = "restic-integrity";
  };
}
