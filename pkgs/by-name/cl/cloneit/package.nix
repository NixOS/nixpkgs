{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  unstableGitUpdater,
}:
rustPlatform.buildRustPackage {
  pname = "cloneit";
  version = "0-unstable-2024-06-28";

  src = fetchFromGitHub {
    owner = "alok8bb";
    repo = "cloneit";
    rev = "6198556e810d964cc5938c446ef42fc21b55fe0b";
    sha256 = "sha256-RP0/kquAlSwRMeB6cjvS5JB9qfdkT8IKLVxaxrmzJ+0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZcowTGIl6RiP6qpP5LqgePCgII+qgEcebe5pq4ubv6o=";

  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "CLI tool to download specific GitHub directories or files";
    homepage = "https://github.com/alok8bb/cloneit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NotAShelf ];
    platforms = lib.platforms.linux;
  };
}
