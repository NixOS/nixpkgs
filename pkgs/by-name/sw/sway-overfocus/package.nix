{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "sway-overfocus";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "korreman";
    repo = "sway-overfocus";
    rev = "v${version}";
    hash = "sha256-Ik1YkEtmnMdm5bQb5PtqzZZdJxCnGu4Bzt000iV7tc4=";
  };

  cargoHash = "sha256-sMciCYeuvgY6K7u9HHxIL9EaCUAWGqtbcSjhfcbjdXI=";

  # Crate without tests.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Better focus navigation for sway and i3";
    homepage = "https://github.com/korreman/sway-overfocus";
    changelog = "https://github.com/korreman/sway-overfocus/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ maintainers.ivan770 ];
    mainProgram = "sway-overfocus";
  };
}
