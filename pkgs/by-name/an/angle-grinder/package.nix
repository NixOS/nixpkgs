{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "angle-grinder";
  version = "0.19.6";

  src = fetchFromGitHub {
    owner = "rcoh";
    repo = "angle-grinder";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-CkDDX9U3e57fbKA9hwdy1AZ/ZDNpIFe6uvemmc6DcKA=";
  };

  cargoHash = "sha256-w1+wdvl4wmxOynsg7SmL5lSASd4Cl4OkMJoIBUmuKGY=";

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Slice and dice logs on the command line";
    homepage = "https://github.com/rcoh/angle-grinder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bbigras ];
    mainProgram = "agrind";
  };
})
