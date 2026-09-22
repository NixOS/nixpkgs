{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  nix-update-script,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fsel";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "Mjoyufull";
    repo = "fsel";
    tag = finalAttrs.version;
    hash = "sha256-yUenkuZ5ryUSpeGjJPO7xgbMObZ5SeBs8/LKU3ROo4g=";
  };

  cargoHash = "sha256-WmHrMALgP52OJH1acrB7DMgo/8FMgksPyXpeRL9Q7s0=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  postInstall = ''
    installManPage fsel.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast TUI app launcher and fuzzy finder for GNU/Linux and *BSD";
    homepage = "https://github.com/Mjoyufull/fsel";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nettika ];
    mainProgram = "fsel";
    platforms = with lib.platforms; linux ++ freebsd ++ openbsd ++ netbsd;
  };
})
