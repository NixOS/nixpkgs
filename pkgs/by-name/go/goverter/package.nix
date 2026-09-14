{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "goverter";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "jmattheis";
    repo = "goverter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/5Wdu0mfzOSI7vsDwuVPIEX1hLecUHNW16Lm/14XB9c=";
  };

  vendorHash = "sha256-4laZspdBxhXlmSV5dBNfMPkZ7h/iWcaTIKG4q12Lfb8=";

  subPackages = [ "cmd/goverter" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate type-safe Go converters by defining function signatures";
    homepage = "https://github.com/jmattheis/goverter";
    changelog = "https://goverter.jmattheis.de/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ krostar ];
    mainProgram = "goverter";
  };
})
