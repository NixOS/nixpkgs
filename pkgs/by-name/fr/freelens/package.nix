{
  appimageTools,
  fetchurl,
  makeWrapper,
  lib,
}:
let
  pname = "freelens";
  version = "1.5.3";

  src = fetchurl {
    url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-amd64.AppImage";
    sha256 = "sha256-I6jmMGCkkdZPJoLNGfWhUc5SAjNcRzPJsVckxZ6eeng=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/freelens.desktop -t $out/share/applications
    install -m 444 -D ${appimageContents}/freelens.png $out/share/icons/hicolor/256x256/apps/freelens.png
    substituteInPlace $out/share/applications/freelens.desktop --replace-fail 'Exec=AppRun' 'Exec=freelens'
    wrapProgram $out/bin/freelens --set XDG_CURRENT_DESKTOP GNOME
  '';

  meta = {
    description = "Freelens is a free and open-source user interface designed for managing Kubernetes clusters.";
    homepage = "https://freelensapp.github.io/";
    changelog = "https://github.com/freelensapp/freelens/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "freelens";
    maintainers = with lib.maintainers; [ vitorpavani ];
    platforms = [ "x86_64-linux" ];
  };
}
