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
  version = "0.1-unstable-2026-04-17";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "1f71628d86a7701fd5ba0f8aeabe15376f4c6afc";
    hash = "sha256-3rROoGl8xBsIOM+5m+qZS4GJnsdQPAH3NJJe1OUfJ5o=";
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
