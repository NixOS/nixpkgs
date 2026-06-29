{
  appimageTools,
  fetchurl,
  lib,
  nix-update-script,
}:
let
  pname = "helium";
  version = "0.13.6.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-ZcZo/vFXWrZjuPjIt2MYbsxs4LU7NvpB3I6mrPzAJjE=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  strictDeps = true;
  __structuredAttrs = true;

  extraPkgs = pkgs: [ ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/*.desktop -t $out/share/applications
    if [ -d ${appimageContents}/usr/share/icons ]; then
      cp -r ${appimageContents}/usr/share/icons $out/share/
    fi
    substituteInPlace $out/share/applications/*.desktop \
      --replace-quiet 'Exec=AppRun' 'Exec=helium'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Private, fast, and honest Chromium-based web browser";
    longDescription = ''
      Helium is a Chromium-based browser focused on privacy: best privacy by
      default, unbiased ad-blocking, and no bloat. Fully open source.
    '';
    homepage = "https://helium.computer/";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "helium";
    maintainers = with lib.maintainers; [ jupiterScope ];
    platforms = [ "x86_64-linux" ];
  };
}
