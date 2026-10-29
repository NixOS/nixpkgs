{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  scdoc,
  coreutils,
  grim,
  hyprland,
  hyprpicker,
  jq,
  libnotify,
  slurp,
  wl-clipboard,
  unixtools,
  glib,
  bash,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "grimblast";
  version = "0.1-unstable-2026-03-28";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "b3c2a094163cad4aac7af09333fddf2c9838c348";
    hash = "sha256-xr3Ih1HrAIlO9GGrmnVrmRh50GSPMWI4QWmbEwlbYq8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    scdoc
  ];

  buildInputs = [ bash ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  sourceRoot = "${finalAttrs.src.name}/grimblast";

  postInstall = ''
    wrapProgram $out/bin/grimblast --prefix PATH ':' \
      "${
        lib.makeBinPath [
          coreutils
          grim
          hyprland
          hyprpicker
          jq
          libnotify
          slurp
          wl-clipboard
          unixtools.getopt
          glib
        ]
      }"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Helper for screenshots within Hyprland, based on grimshot";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.hyprland ];
    mainProgram = "grimblast";
  };
})
