{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fakedir";
  version = "0-unstable-2025-12-02";

  src = fetchFromGitHub {
    owner = "nixie-dev";
    repo = "fakedir";
    rev = "82bfac1f58a76f56fc4ef928982f507e01c552a5";
    hash = "sha256-wPseLfbRffX0Pr4TxJh59cmuY1OEfSDTvM2KrORafKs=";
  };

  CFLAGS = "-Ofast -DSTRIP_DEBUG";

  installPhase = ''
    install -Dm755 libfakedir.dylib $out/lib/libfakedir.dylib
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=(0-unstable-.*)"
    ];
  };

  meta = {
    description = "Substitutes a directory elsewhere on macOS by replacing system calls";
    homepage = "https://github.com/nixie-dev/fakedir";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ eveeifyeve ];
    mainProgram = "fakedir";
    platforms = lib.platforms.darwin;
  };
})
