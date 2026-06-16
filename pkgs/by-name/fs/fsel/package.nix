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
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "Mjoyufull";
    repo = "fsel";
    tag = finalAttrs.version;
    hash = "sha256-XGKD/DId5Eont4ytPV7LfGvykDRalMWx4pbkRVUNzxY=";
  };

  cargoHash = "sha256-SAQnY0VgRPLjkjmEgZcyjp6hFXxp54PB1j52qwAy9yI=";

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
