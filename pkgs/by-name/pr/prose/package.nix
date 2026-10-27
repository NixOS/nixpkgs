{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prose";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "jgdavey";
    repo = "prose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YMRCdHDxZ3PMbRn1Ct+oQEMV1TgJa3VIMPVE2lK+tX8=";
  };

  cargoHash = "sha256-DT8ZlH5CG4VDzT5x5OtuRK//IguV8d+6F4vwdhZ/Rns=";

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A CLI utility to reformat text";
    homepage = "https://github.com/jgdavey/prose";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ MoritzBoehme ];
    mainProgram = "prose";
  };
})
