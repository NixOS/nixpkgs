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
  version = "0.1-unstable-2025-03-31";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "bc2ad24e0b2e66c3e164994c4897cd94a933fd10";
    hash = "sha256-YItzk1pj8Kz+b7VlC9zN1pSZ6CuX35asYy3HuMQ3lBQ=";
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
