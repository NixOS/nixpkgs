{
  lib,
  fetchFromGitHub,
  rustPlatform,
  coreutils,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "heatseeker";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "rschmitt";
    repo = "heatseeker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hfx2QTfSJ6lh/K3ZdJzXqgxGOVbC2i2ZqZKH8Wtj/6k=";
  };

  cargoHash = "sha256-8ZrPHm+W4lxVzupgeLcCQmpNRJS3aEaSWWKPkGVZVTg=";

  # https://github.com/rschmitt/heatseeker/issues/42
  # I've suggested using `/usr/bin/env stty`, but doing that isn't quite as simple
  # as a substitution, and this works since we have the path to coreutils stty.
  patchPhase = ''
    substituteInPlace src/screen/unix.rs --replace "/bin/stty" "${coreutils}/bin/stty"
  '';

  # skip the TTY-only test
  checkFlags = [
    "--skip"
    "screen::unix::tests::winsize_test"
  ];

  meta = {
    description = "General-purpose fuzzy selector";
    homepage = "https://github.com/rschmitt/heatseeker";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "hs";
    platforms = lib.platforms.unix;
  };
})
