{ lib
, rustPlatform
, fetchFromGitea
}:

rustPlatform.buildRustPackage rec {
  pname = "restic-integrity";
  version = "1.3.0";

  src = fetchFromGitea {
    domain = "git.nwex.de";
    owner = "networkException";
    repo = "restic-integrity";
    rev = version;
    hash = "sha256-mryHePqfEawW/vLgxfm+eh4oSbcALhxvRid4kF9klTs=";
  };

  cargoHash = "sha256-0BvB1ijsppblEC2PNLfVt+sgM4wTdSLZ/RoDH4JrQy4=";

  meta = with lib; {
    description = "CLI tool to check the integrity of a restic repository without unlocking it";
    homepage = "https://git.nwex.de/networkException/restic-integrity";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ networkexception ];
    mainProgram = "restic-integrity";
  };
}
