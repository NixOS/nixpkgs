{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  hyprland,
  jq,
  grim,
  slurp,
  wl-clipboard,
  libnotify,
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

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 hyprshot -t "$out/bin"
    wrapProgram "$out/bin/hyprshot" \
      --prefix PATH ":" ${
        lib.makeBinPath [
          hyprland
          jq
          grim
          slurp
          wl-clipboard
          libnotify
        ]
      }

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Gustash/hyprshot";
    description = "Hyprshot is an utility to easily take screenshots in Hyprland using your mouse";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Cryolitia ];
    mainProgram = "hyprshot";
    platforms = hyprland.meta.platforms;
  };
})
