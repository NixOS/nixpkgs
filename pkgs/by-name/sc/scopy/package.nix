{
  appimageTools,
  fetchzip,
  lib,
  stdenv,
}:

let
  pname = "scopy";
  version = "2.0.0";

  src =
    let
      linuxArch =
        let
          inherit (stdenv.hostPlatform) linuxArch;

        in
        if linuxArch != "armv7a" then linuxArch else "armhf";

      base = "Scopy-v${version}-Linux-${linuxArch}";

      src = fetchzip {
        url = "https://github.com/analogdevicesinc/scopy/releases/download/v${version}/${base}-AppImage.zip";
        hash = "sha256-MoJPeAo3CLRdA2TCTBUVdJ4AAfSYurqmUsLh8ZW84BQ=";
      };

    in
    "${src}/${base}.AppImage";

  appimageContents = appimageTools.extractType2 {
    inherit pname;
    inherit version;
    inherit src;
  };

in
appimageTools.wrapType2 {
  inherit pname;
  inherit version;
  inherit src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/scopy.desktop \
      $out/share/applications/scopy.desktop

    install -m 444 -D ${appimageContents}/scopy.png \
      $out/share/icons/hicolor/512x512/apps/scopy.png
  '';

  meta = with lib; {
    homepage = "https://analogdevicesinc.github.io/scopy/";
    description = "Software oscilloscope and signal analysis toolset";
    license = licenses.gpl3Plus;
    platforms = [
      "aarch64-linux"
      "armv7a-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [
      jacobkoziej
    ];
  };
}
