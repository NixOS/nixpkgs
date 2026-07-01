{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "reef-wm-bin";
  version = "1.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/gouwsxander/Reef/releases/download/${finalAttrs.version}/Reef.zip";
    hash = "sha256-sXLbFt1PanPkw5hjux0XRQup+0tM8BXdWfLgtuKWees=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    appdir="$out/Applications/Reef.app"
    mkdir -p $appdir $out/bin
    cp -r * $appdir
    makeWrapper $appdir/Contents/MacOS/Reef $out/bin/reef
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--url=https://github.com/gouwsxander/Reef"
      "--use-github-releases" # to get the correct latest release
    ];
  };

  meta = {
    description = "macOS window manager that gives every app its own Alt-Tab";
    homepage = "https://getreef.app";
    changelog = "https://github.com/gouwsxander/Reef/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "reef";
  };
})
