{
  lib,
  fetchgit,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "spl";
  version = "0.3.2";
  src = fetchgit {
    url = "https://git.tudbut.de/tudbut/spl";
    rev = "v${version}";
    hash = "sha256-thTKM07EtgAVvjpIx8pVssTmN0jPK/OrPYhRfwp7T+U=";
  };

  cargoHash = "sha256-7MYwWA3F7uJewmBRR0iQD4iXJZokHqIt9Q9dMoj6JVs=";

  meta = {
    description = "Simple, concise, concatenative scripting language";
    homepage = "https://git.tudbut.de/tudbut/spl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tudbut ];
    mainProgram = "spl";
  };
}
