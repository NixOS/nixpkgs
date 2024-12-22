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

  cargoHash = "sha256-XXcqmDPEQUm4YBqY5+06X55ym3o3RqE7fNSiR4n+iyc=";

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
