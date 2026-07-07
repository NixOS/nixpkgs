{
  stdenv,
  fetchFromCodeberg,
  lib,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "kbd-ergol";
  version = "0-unstable-2026-07-03";

  src = fetchFromCodeberg {
    owner = "Alerymin";
    repo = "kbd-ergol";
    rev = "5111b8c90cee7daddb6c49115ba1ca665b2102ab";
    hash = "sha256-kkxsTFNXGO8dly8r/EQyKL/JWZC4hUnq67rHChhwmkU=";
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
