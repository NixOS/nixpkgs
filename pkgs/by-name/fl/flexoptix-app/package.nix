{
  lib,
  appimageTools,
  fetchurl,
  asar,
  python3,
}:
let
  pname = "flexoptix-app";
  version = "5.43.0-latest";

  src = fetchurl {
    name = "${pname}-${version}.AppImage";
    url = "https://flexbox.reconfigure.me/download/electron/linux/x64/FLEXOPTIX%20App.${version}.AppImage";
    hash = "sha256-DWVk+gtz6bym3ngiToO04VFIMeJWKUcaNjAY3a9xa5M=";
  };

  udevRules = fetchurl {
    url = "https://www.flexoptix.net/static/frontend/Flexoptix/default/en_US/files/99-tprogrammer.rules";
    hash = "sha256-/1ZtJT+1IMyYqw3N0bVJ/T3vbmex169lzx+SlY5WsnA=";
  };

  appimageContents = (appimageTools.extract { inherit pname version src; }).overrideAttrs (oA: {
    buildCommand = ''
      ${oA.buildCommand}

      # Remove left-over node-gyp executable symlinks
      # https://github.com/nodejs/node-gyp/issues/2713
      find $out/ -type l -name python3 -exec ln -sf ${python3.interpreter} {} \;

      # Get rid of the autoupdater
      ${asar}/bin/asar extract $out/resources/app.asar app
      patch -p0 < ${./disable-autoupdate.patch}
      ${asar}/bin/asar pack app $out/resources/app.asar
    '';
  });

in
appimageTools.wrapAppImage {
  inherit pname version;
  src = appimageContents;

  extraPkgs = pkgs: [ pkgs.hidapi ];

  extraInstallCommands = ''
    # Add desktop convencience stuff
    install -Dm444 ${appimageContents}/flexoptix-app.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/flexoptix-app.png -t $out/share/pixmaps
    substituteInPlace $out/share/applications/flexoptix-app.desktop \
      --replace 'Exec=AppRun' "Exec=$out/bin/${pname} --"

    # Add udev rules
    mkdir -p $out/lib/udev/rules.d
    ln -s ${udevRules} $out/lib/udev/rules.d/99-tprogrammer.rules
  '';

  meta = {
    description = "Configure FLEXOPTIX Universal Transceivers in seconds";
    homepage = "https://www.flexoptix.net";
    changelog = "https://www.flexoptix.net/en/flexoptix-app/?os=linux#flexapp__modal__changelog";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ das_j ];
    platforms = [ "x86_64-linux" ];
  };
}
