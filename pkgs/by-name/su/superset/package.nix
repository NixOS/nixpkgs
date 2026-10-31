{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
}:

let
  pname = "superset";
  version = "1.31.0";

  src = fetchurl {
    url = "https://github.com/superset-sh/superset/releases/download/desktop-v${version}/superset-${version}-x86_64.AppImage";
    hash = "sha256-g9k4N4JkZkfNHuPyvnyaAjxoPK0kH4tbBwfGBA6hH5M=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/superset.desktop -t $out/share/applications
    # Upstream's desktop entry launches the AppImage's internal AppRun, which is not on PATH
    substituteInPlace $out/share/applications/superset.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=superset'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=desktop-v(.*)" ];
  };

  meta = {
    description = "Desktop app for orchestrating multiple coding agents in parallel git worktrees";
    homepage = "https://superset.sh";
    changelog = "https://github.com/superset-sh/superset/releases/tag/desktop-v${version}";
    downloadPage = "https://github.com/superset-sh/superset/releases";
    license = lib.licenses.elastic20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ PascalOrdano18 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "superset";
  };
}
