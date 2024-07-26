{ lib
, stdenvNoCC
, fetchFromGitHub
, makeWrapper
, scdoc
, coreutils
, grim
, hyprland
, hyprpicker
, jq
, libnotify
, slurp
, wl-clipboard
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "grimblast";
  version = "unstable-2024-01-11";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "89c56351e48785070b60e224ea1717ac50c3befb";
    hash = "sha256-EjdQsk5VIQs7INBugbgX1I9Q3kPAOZSwkXXqEjZL0E0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    scdoc
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  sourceRoot = "${finalAttrs.src.name}/grimblast";

  postInstall = ''
    wrapProgram $out/bin/grimblast --prefix PATH ':' \
      "${lib.makeBinPath [
        coreutils
        grim
        hyprland
        hyprpicker
        jq
        libnotify
        slurp
        wl-clipboard
      ]}"
  '';

  meta = with lib; {
    description = "A helper for screenshots within Hyprland, based on grimshot";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "grimblast";
  };
})
