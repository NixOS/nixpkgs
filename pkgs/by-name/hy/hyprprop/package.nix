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
  version = "0.1-unstable-2025-07-23";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "6839b23345b71db17cd408373de4f5605bf589b8";
    hash = "sha256-PFAJoEqQWMlo1J+yZb+4HixmhbRVmmNl58e/AkLYDDI=";
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
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprprop";
  };
})
