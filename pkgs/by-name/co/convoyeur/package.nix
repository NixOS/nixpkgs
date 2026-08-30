{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "convoyeur";
  version = "0.1.1";

  src = fetchFromCodeberg {
    owner = "classabbyamp";
    repo = "convoyeur";
    tag = "v${version}";
    hash = "sha256-gfOmi3yyGEjGPooWocCBIO5wR5hKgz4HmbJBiIMh4RE=";
  };

  cargoHash = "sha256-rMRKTaKleO5QNeLM0jAOJ2kCKGfJxQWACWTqU8A8wt8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "IRCv3 FILEHOST extension adapter to external file upload services";
    homepage = "https://codeberg.org/classabbyamp/convoyeur";
    mainProgram = "convoyeur";
    license = lib.licenses.liliq-p-11;
    maintainers = with lib.maintainers; [ lenny ];
  };
}
