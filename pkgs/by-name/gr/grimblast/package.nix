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
  bash,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "grimblast";
  version = "0.1-unstable-2025-07-23";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "6839b23345b71db17cd408373de4f5605bf589b8";
    hash = "sha256-PFAJoEqQWMlo1J+yZb+4HixmhbRVmmNl58e/AkLYDDI=";
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
        ]
      }"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = with lib; {
    description = "Helper for screenshots within Hyprland, based on grimshot";
    license = licenses.mit;
    platforms = platforms.unix;
    teams = [ lib.teams.hyprland ];
    mainProgram = "grimblast";
  };
})
