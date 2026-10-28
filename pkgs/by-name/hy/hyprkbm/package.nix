{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  python3,
  lua5_4,
  libnotify,
  quickshell,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hyprkbm";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "phos-org";
    repo = "hyprKBM";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fI+uuxV7LoujejIhMRWAYgSYcU6839pRV99IsrW/qf0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  dontBuild = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  # hyprctl comes from the running Hyprland; Lua reads hyprland.lua, Quickshell
  # draws the panel and the cheatsheet, notify-send reports a failed apply.
  postFixup = ''
    for tool in hyprkbm hyprkbm-apply hyprkbm-watch; do
      wrapProgram $out/lib/hyprkbm/bin/$tool \
        --prefix PATH : ${
          lib.makeBinPath [
            lua5_4
            quickshell
            libnotify
          ]
        }
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keyboard-first keybind manager for Hyprland's Lua config";
    homepage = "https://github.com/phos-org/hyprKBM";
    changelog = "https://github.com/phos-org/hyprKBM/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "hyprkbm";
    maintainers = with lib.maintainers; [ kakaouskias ];
  };
})
