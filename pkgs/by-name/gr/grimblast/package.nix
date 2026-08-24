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
  version = "0.1-unstable-2026-08-21";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "57baf317e5196a8286b80976771ef55febad8660";
    hash = "sha256-qSzrIIqQUtEVeVZxQLj/L4p7+xKBEtPhgMTzFW2c6P8=";
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
    homepage = "https://github.com/hyprwm/contrib";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.hyprland ];
    mainProgram = "grimblast";
  };
})
