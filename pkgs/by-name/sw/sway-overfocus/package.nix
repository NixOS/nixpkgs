{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "sway-overfocus";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "korreman";
    repo = "sway-overfocus";
    rev = "v${version}";
    hash = "sha256-trpjKA0TV8InSfViIXKnMDeZeFXZfavpiU7/R3JDQkQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RtiXcUvId+bf8t74Ld2JXQGx+o094Qo3O5kt+ldm1Ag=";

  # Crate without tests.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = ''"Better" focus navigation for sway and i3.'';
    homepage = "https://github.com/korreman/sway-overfocus";
    changelog = "https://github.com/korreman/sway-overfocus/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ maintainers.ivan770 ];
    mainProgram = "sway-overfocus";
  };
}
