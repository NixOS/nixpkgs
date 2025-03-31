{
  lib, # Dependencies/arguments
  fetchFromSourcehut,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  # Main package definition
  pname = "cnsprcy";
  version = "0.3.0";

  src = fetchFromSourcehut {
    # Fetching the sourcecode
    owner = "~xaos";
    repo = "cnsprcy";
    rev = "v0.3.0";
    hash = "sha256-OBNl2ZZi1jmJjJvzCwaIN9DSYjGaEo0g4o7/vVOF5aQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  passthru.updateScript = lib.mkUpdateScript {
    extraFetchers = [ fetchFromSourcehut ];
  };

  RUSTC_BOOTSTRAP = true;

  buildInputs = [ sqlite ];

  meta = {
    # Metatdata
    description = "End to end encrypted connections between trusted devices";
    homepage = "https://git.sr.ht/~xaos/cnsprcy";
    license = lib.licenses.gpl3;
    maintainers =
      with lib.maintainers;
      [
        supinie
        oluchitheanalyst
      ]
      ++ lib.teams.ngi.members;
    mainProgram = "cnspr";
    platforms = lib.platforms.linux;
  };
}
