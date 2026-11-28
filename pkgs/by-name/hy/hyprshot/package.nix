{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  fetchpatch,
  hyprland,
  jq,
  grim,
  slurp,
  wl-clipboard,
  libnotify,
  withFreeze ? true,
  hyprpicker,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hyprshot";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Gustash";
    repo = "hyprshot";
    rev = finalAttrs.version;
    hash = "sha256-9taTmV357cWglMGuN3NLq3bfNneFthwV6y+Ml4qEeHA=";
  };

  patches = [
    # Fix clipboard wipe and false notification on cancelled selection
    # https://github.com/Gustash/Hyprshot/pull/156
    (fetchpatch {
      name = "fix-cancel-clipboard-wipe.patch";
      url = "https://github.com/Gustash/Hyprshot/commit/ceefa2ae488656548574a94bb4562e0e126bf448.patch";
      hash = "sha256-Za04FGqNMwu1X3P2Hzid5arkH3iEWddhVuUNn4sVfQ4=";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 hyprshot -t "$out/bin"
    wrapProgram "$out/bin/hyprshot" \
      --prefix PATH ":" ${
        lib.makeBinPath (
          [
            hyprland
            jq
            grim
            slurp
            wl-clipboard
            libnotify
          ]
          ++ lib.optionals withFreeze [ hyprpicker ]
        )
      }

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Gustash/hyprshot";
    description = "Utility to easily take screenshots in Hyprland using your mouse";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      Cryolitia
      ryan4yin
    ];
    mainProgram = "hyprshot";
    platforms = hyprland.meta.platforms;
  };
})
