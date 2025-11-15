{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "canopy";
  version = "0.2.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hnpf";
    repo = "canopy";
    # Upstream tags do not contain the version number
    tag = "Canopy-post";
    hash = "sha256-X4/3ELf69RKikYcq+9YKjBaj2sA7sB0QYHwoEWa/1bE=";
  };

  # Upstream deleted Cargo.lock from the repository.  This is the last
  # committed upstream Cargo.lock, with the version of the root package bumped.
  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "Generate and visualize directory tree structures";
    homepage = "https://github.com/hnpf/canopy";
    changelog = "https://github.com/hnpf/canopy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "virex-canopy";
  };
})
