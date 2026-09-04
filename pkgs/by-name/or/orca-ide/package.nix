{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  makeWrapper,
}:
let
  pname = "orca-ide";
  version = "1.4.173";
  sources = {
    x86_64-linux = {
      url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux.AppImage";
      hash = "sha256-+pAiq3aewtqNTPpj34F8tUtIg2D81Edc+Yxa1Pb8dUQ=";
    };
    aarch64-linux = {
      url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux-arm64.AppImage";
      hash = "sha256-TdvTWiDb6gBti3RW2hGPeu0Ehe4XiEzTr1MtFv69U6Y=";
    };
  };
  src = fetchurl (
    sources.${stdenv.hostPlatform.system}
      or (throw "orca-ide: unsupported system ${stdenv.hostPlatform.system}")
  );
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;
  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/orca-ide.desktop \
      -t $out/share/applications
    substituteInPlace $out/share/applications/orca-ide.desktop \
      --replace-fail "Exec=AppRun --no-sandbox %U" "Exec=orca-ide %U"
    install -m 444 -D ${appimageContents}/orca-ide.png \
      $out/share/icons/hicolor/512x512/apps/orca-ide.png
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

  extraPkgs = pkgs: [ pkgs.procps ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "ADE for working with a fleet of parallel AI coding agents in isolated git worktrees";
    homepage = "https://onorca.dev/";
    changelog = "https://github.com/stablyai/orca/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      kreativmonkey
    ];
    mainProgram = pname;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
