{
  lib,
  fetchFromGitHub,
  gpgme,
  nix-update-script,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "passepartui";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "kardwen";
    repo = "passepartui";
    tag = "v${version}";
    hash = "sha256-LV/2+oSGVBRrWaHP/u1PcCb1T6Nduna/lusakCZW+PM=";
  };

  cargoHash = "sha256-JR5zOhYogBa+6xYYyc36n/x7f5JW1mnNi2cK5i9QMSM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gpgme ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI for pass, the standard unix password manager";
    homepage = "https://github.com/kardwen/passepartui";
    changelog = "https://github.com/kardwen/passepartui/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "passepartui";
  };
}
