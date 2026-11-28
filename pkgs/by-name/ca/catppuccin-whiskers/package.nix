{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
let
  version = "2.10.0";
in
rustPlatform.buildRustPackage {
  pname = "catppuccin-whiskers";
  inherit version;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "whiskers";
    tag = "v${version}";
    hash = "sha256-ca8wKCaE6S/Rqw2I1lDbNAlN/D1wHUgXzv7JIxgeOvk=";
  };

  cargoHash = "sha256-IxkNPl6GkNVb/71O7wHo9Ld9E42Rx0l3SJdb1J4NoOI=";

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/catppuccin/whiskers";
    description = "Templating tool to simplify the creation of Catppuccin ports";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Name
      isabelroses
    ];
    mainProgram = "whiskers";
  };
}
