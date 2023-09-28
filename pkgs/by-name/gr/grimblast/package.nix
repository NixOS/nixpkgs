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
  version = "unstable-2023-09-06";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "5b67181fced4fb06d26afcf9614b35765c576168";
    hash = "sha256-W23nMGmDnyBgxO8O/9jcZtiSpa0taMNcRAD1das/ttw=";
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
