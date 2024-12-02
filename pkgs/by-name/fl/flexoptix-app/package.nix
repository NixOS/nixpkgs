{ lib, appimageTools, fetchurl, asar }: let
  pname = "flexoptix-app";
  version = "5.21.2-latest";

  src = fetchurl {
    name = "${pname}-${version}.AppImage";
    url = "https://flexbox.reconfigure.me/download/electron/linux/x64/FLEXOPTIX%20App.${version}.AppImage";
    hash = "sha256-BnNRwD09CE1EZDg3Hn3khN4FZ8Hj5LLAunk+NKU5BJo=";
  };

  udevRules = fetchurl {
    url = "https://www.flexoptix.net/static/frontend/Flexoptix/default/en_US/files/99-tprogrammer.rules";
    hash = "sha256-OZe5dV50xq99olImbo7JQxPjRd7hGyBIVwFvtR9cIVc=";
  };

  appimageContents = (appimageTools.extract { inherit pname version src; }).overrideAttrs (oA: {
    buildCommand = ''
      ${oA.buildCommand}

      # Get rid of the autoupdater
      ${asar}/bin/asar extract $out/resources/app.asar app
      patch -p0 < ${./disable-autoupdate.patch}
      ${asar}/bin/asar pack app $out/resources/app.asar
    '';
  });

in appimageTools.wrapAppImage {
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
