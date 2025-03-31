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
  version = "0.1-unstable-2025-03-17";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "bd81329944be53b0ffb99e05864804b95f1d7c65";
    hash = "sha256-I8JVdQRu8eWvY5W8XWYZkdd5pojDHkxeqQV7mMIsbhs=";
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
    description = "An xprop replacement for Hyprland";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = lib.teams.hyprland.members;
    mainProgram = "hyprprop";
  };
})
