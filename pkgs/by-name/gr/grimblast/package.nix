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
  version = "0.1-unstable-2024-12-01";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "contrib";
    rev = "d7c55140f1785b8d9fef351f1cd2a4c9e1eaa466";
    hash = "sha256-sp14z0mrqrtmouz1+bU4Jh8/0xi+xwQHF2l7mhGSSVU=";
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
    maintainers = with maintainers; [
      donovanglover
      khaneliman
    ];
    mainProgram = "grimblast";
  };
})
