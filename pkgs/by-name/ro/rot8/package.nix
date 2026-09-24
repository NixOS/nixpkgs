{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rot8";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "efernau";
    repo = "rot8";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9zjAi4yIpTqcJ338t0CVoOo0jlzrzRMfTH4ZRqBVAQg=";
  };

  # Upstream dropped Cargo.lock from the repo, so it has to be
  # generated manually with `cargo generate-lockfile`.
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "Screen rotation daemon for X11 and wlroots";
    homepage = "https://github.com/efernau/rot8";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.smona ];
    mainProgram = "rot8";
    platforms = lib.platforms.linux;
  };
})
