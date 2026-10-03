{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nsh";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "nuta";
    repo = "nsh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d7FMQYbMjb+ENcfWLuHX21tQ8PJ3H3E5A0vQAtHm6ZA=";
  };

  cargoHash = "sha256-kbHNFVu5OIg/eKefhsYRGvlXFduB0aBVflPV9hkM4Ec=";

  doCheck = false;

  meta = {
    description = "Command-line shell like fish, but POSIX compatible";
    mainProgram = "nsh";
    homepage = "https://github.com/nuta/nsh";
    changelog = "https://github.com/nuta/nsh/raw/v${finalAttrs.version}/docs/changelog.md";
    license = [
      lib.licenses.cc0 # or
      lib.licenses.mit
    ];
    maintainers = with lib.maintainers; [ cafkafk ];
  };

  passthru = {
    shellPath = "/bin/nsh";
  };
})
