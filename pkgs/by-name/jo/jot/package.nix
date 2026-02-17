{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jot";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "shashwatah";
    repo = "jot";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Z8szd6ArwbGiHw7SeAah0LrrzUbcQYygX7IcPUYNxvM=";
  };

  cargoHash = "sha256-B3CkXoSShZTnT3OlVaqRBbGIaOKiqri6AuYVrUHB6NQ=";

  meta = {
    description = "Rapid note management for the terminal";
    homepage = "https://github.com/shashwatah/jot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "jt";
  };
})
