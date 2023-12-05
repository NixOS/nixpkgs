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
  version = "unstable-2023-10-03";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "2e3f8ac2a3f1334fd2e211b07ed76b4215bb0542";
    hash = "sha256-rb954Rc+IyUiiXoIuQOJRp0//zH/WeMYZ3yJ5CccODA=";
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
