{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "swayr";
  version = "0.28.2";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayr-${version}";
    hash = "sha256-uT8MYgH9kANQ0t+7jqjOOvQIZf5ImdQruZLLlCejwcc=";
  };

  cargoHash = "sha256-Aj4U2xyfNhf3HDSEd1SQ5TyO2MXn2/hrfnG0ZayzMtU=";

  patches = [
    ./icon-paths.patch
  ];

  # don't build swayrbar
  buildAndTestSubdir = pname;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = {
    description = "Window switcher (and more) for sway";
    homepage = "https://git.sr.ht/~tsdh/swayr";
    license = lib.licenses.gpl3Plus;
    mainProgram = "swayr";
    maintainers = with lib.maintainers; [ artturin ];
    platforms = lib.platforms.linux;
  };
}
