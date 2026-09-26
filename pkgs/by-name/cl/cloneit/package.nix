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
  version = "1.0.0-unstable-2025-07-22";

  src = fetchFromGitHub {
    owner = "alok8bb";
    repo = "cloneit";
    rev = "58e9213ba5af457e76a7ea55696eb77f6d0d9025";
    sha256 = "sha256-rvhUArJR8ipMRIWpzUY9NUBwqj9TWjX6qtBJp/v3p+Q=";
  };

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
