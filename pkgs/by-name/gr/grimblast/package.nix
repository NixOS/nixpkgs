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
  version = "0.1-unstable-2025-03-17";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "bd81329944be53b0ffb99e05864804b95f1d7c65";
    hash = "sha256-I8JVdQRu8eWvY5W8XWYZkdd5pojDHkxeqQV7mMIsbhs=";
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
    maintainers = lib.teams.hyprland.members;
    mainProgram = "grimblast";
  };
})
