{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "frezze";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "AbelHristodor";
    repo = "frezze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zJi0cTh60vyiQ9SDKl9IVmaAbdyJmOv2eJc+LA9oFlk=";
  };

  cargoHash = "sha256-jnEaC5X7NqTucWIX94txhDaSSos2t74v+jAYZKzyVdg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Block developers from merging anything on Github";
    homepage = "https://github.com/AbelHristodor/frezze";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "frezze";
  };
})
