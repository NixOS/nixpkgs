{
  lib,
  fetchFromGitHub,
  rustPlatform,
  coreutils,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "heatseeker";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "rschmitt";
    repo = "heatseeker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yIFMwC7W/vn7HOAJ1+HGFzPq4k+KF7mqua0XZteDBRg=";
  };

  cargoHash = "sha256-qBTHNArPgf/qrce6hP3GJ1f9NcJ5OmSokCs5IVtyJQQ=";

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
