{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swayr";
  version = "0.28.3";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayr-${finalAttrs.version}";
    hash = "sha256-FbkOJzfma0kmiSyAmBkHyD1mVlOTIcB6Xh/fiSB95BE=";
  };

  cargoHash = "sha256-4d0G8YsgZ3yMXnOS2oPfXCYBQnYDSnws0FaleN/RUeg=";

  patches = [
    ./icon-paths.patch
  ];

  # don't build swayrbar
  buildAndTestSubdir = finalAttrs.pname;

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
})
