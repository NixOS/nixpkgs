{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  nix-update-script,
}:

let
  version = "0.5.3";
in
rustPlatform.buildRustPackage {
  pname = "sd-switch";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~rycee";
    repo = "sd-switch";
    rev = version;
    hash = "sha256-9aIu37mmf4ZnmZZrU0GA6z+bHKwtfkA5KnLRLY0c2r8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2DpaO64EehlgG5zSzqERmenmEqUbhEwFmIQEmCKs4Wg=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Systemd unit switcher for Home Manager";
    mainProgram = "sd-switch";
    homepage = "https://git.sr.ht/~rycee/sd-switch";
    changelog = "https://git.sr.ht/~rycee/sd-switch/refs/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.linux;
  };
}
