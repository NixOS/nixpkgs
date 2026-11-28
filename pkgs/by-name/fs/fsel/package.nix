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
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "Mjoyufull";
    repo = "fsel";
    tag = finalAttrs.version;
    hash = "sha256-MS48+slpKN9WTWaBfVJlTy3uxcsLhP5GFHbZEQNNKkE=";
  };

  cargoHash = "sha256-ChyjWuRLEzF6E+M/atZFE+7eDNNDgcCv/WRYuNnX134=";

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
