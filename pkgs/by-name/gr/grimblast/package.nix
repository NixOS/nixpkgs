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
  bash,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "grimblast";
<<<<<<< HEAD
  version = "0.1-unstable-2025-12-18";
=======
  version = "0.1-unstable-2025-10-04";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
<<<<<<< HEAD
    rev = "41dbcac8183bb1b3a4ade0d8276b2f2df6ae4690";
    hash = "sha256-d3HmUbmfTDIt9mXEHszqyo2byqQMoyJtUJCZ9U1IqHQ=";
=======
    rev = "32e1a75b65553daefb419f0906ce19e04815aa3a";
    hash = "sha256-PzgQJydp+RlKvwDi807pXPlURdIAVqLppZDga3DwPqg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
        ]
      }"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

<<<<<<< HEAD
  meta = {
    description = "Helper for screenshots within Hyprland, based on grimshot";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Helper for screenshots within Hyprland, based on grimshot";
    license = licenses.mit;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    teams = [ lib.teams.hyprland ];
    mainProgram = "grimblast";
  };
})
