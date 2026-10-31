{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nbted";
  version = "1.5.2-unstable-2026-02-27";

  src = fetchFromGitHub {
    owner = "C4K3";
    repo = "nbted";
    rev = "ce89021a2d84e80331ef7fdc84fa9c53fa80a671";
    hash = "sha256-TCllGon6x4gWlZYIxzcH0GXs/+M57VepyyGz8RyG1o8=";
  };

  cargoHash = "sha256-IMF5vc9p/+M/gMrUxOE3eojdATfera5dD62kcJEpzd8=";

  env.VERGEN_GIT_SHA = finalAttrs.src.rev;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line NBT editor";
    homepage = "https://github.com/C4K3/nbted";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ jaredmontoya ];
    mainProgram = "nbted";
  };
})
