{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "regname";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "linkdd";
    repo = "regname";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oa02AyZxbT2M4MxOCgWvy+4pTyy6WGONHS5U/l3haTA=";
  };

  cargoHash = "sha256-waayV+1Tg3CmPM7mdMc4D0G2BOSk1Mw3ga0O+R3IrwU=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mass renamer TUI written in Rust";
    homepage = "https://github.com/linkdd/regname";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ilarvne ];
    mainProgram = "regname";
  };
})
