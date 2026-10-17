{
  lib,
  stdenvNoCC,
  bash,
  copyDesktopItems,
  coreutils,
  fetchFromGitHub,
  jq,
  makeDesktopItem,
  makeWrapper,
  nix-update-script,
  scdoc,
  slurp,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hyprprop";
  version = "0.1-unstable-2026-10-05";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "a2b16bd4b8550c013ef0a105c8b01bdcc1a270d0";
    hash = "sha256-PeqeCAwPupUO81CH7H6Wa8ez+o+scZy67ZGgx53wVY4=";
  };

  sourceRoot = "${finalAttrs.src.name}/hyprprop";

  buildInputs = [
    bash
    scdoc
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  postInstall = ''
    wrapProgram $out/bin/hyprprop --prefix PATH ':' \
      "${
        lib.makeBinPath [
          coreutils
          slurp
          jq
        ]
      }"
  '';

  desktopItems =
    let
      desktopItem = makeDesktopItem {
        name = "hyprprop";
        exec = "hyprprop";
        desktopName = "Hyprprop";
        terminal = true;
        startupNotify = false;
      };
    in
    [ desktopItem ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  meta = {
    description = "Xprop replacement for Hyprland";
    homepage = "https://github.com/hyprwm/contrib";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprprop";
  };
})
