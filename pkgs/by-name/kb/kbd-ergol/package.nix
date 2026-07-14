{
  stdenv,
  fetchFromCodeberg,
  lib,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "kbd-ergol";
  version = "0-unstable-2026-07-07";

  src = fetchFromCodeberg {
    owner = "Alerymin";
    repo = "kbd-ergol";
    rev = "0af6404625fe4da03bc27e1141dc255ac49fa94e";
    hash = "sha256-875ss78HdU03EgoSpQqLWG279Zg3tIoc6ZTP/hnedcg=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  # console.nix expects keymaps to be under /share/keymaps
  postPatch = ''
    substituteInPlace Makefile \
      --replace "/usr/share/kbd/" "$out/share/"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Ergo-L layout in keymap format for linux console";
    homepage = "https://codeberg.org/Alerymin/kbd-ergol";
    maintainers = with lib.maintainers; [ xaltsc ];
    platforms = lib.platforms.linux;
    license = lib.licenses.wtfpl;
  };
}
