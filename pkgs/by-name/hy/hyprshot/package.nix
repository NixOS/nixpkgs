{ stdenvNoCC
, lib
, fetchFromGitHub
, hyprland
, jq
, grim
, slurp
, wl-clipboard
, libnotify
, makeWrapper
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hyprshot";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "Gustash";
    repo = "hyprshot";
    rev = finalAttrs.version;
    hash = "sha256-sew47VR5ZZaLf1kh0d8Xc5GVYbJ1yWhlug+Wvf+k7iY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 hyprshot -t "$out/bin"
    wrapProgram "$out/bin/hyprshot" \
      --prefix PATH ":" ${lib.makeBinPath [
          hyprland jq grim slurp wl-clipboard libnotify
        ]}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Gustash/hyprshot";
    description = "Hyprshot is an utility to easily take screenshots in Hyprland using your mouse.";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Cryolitia ];
    mainProgram = "hyprshot";
    platforms = hyprland.meta.platforms;
  };
})
