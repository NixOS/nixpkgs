{ lib, appimageTools, fetchurl }:

let
  pname = "chrysalis";
  version = "0.11.5";
in appimageTools.wrapAppImage rec {
  name = "${pname}-${version}-binary";

  src = appimageTools.extract {
    inherit name;
    src = fetchurl {
      url = "https://github.com/keyboardio/${pname}/releases/download/v${version}/${pname}-${version}.AppImage";
      sha256 = "sha256-3GdObGW91nDqOAlHcaI/4wnbl2EG2RGGzpwY+XYQ0u4=";
    };
  };

  multiPkgs = null;
  extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [
    p.glib
  ];

  # Also expose the udev rules here, so it can be used as:
  #   services.udev.packages = [ pkgs.chrysalis ];
  # to allow non-root modifications to the keyboards.

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    mkdir -p $out/lib/udev/rules.d
    ln -s \
      --target-directory=$out/lib/udev/rules.d \
      ${src}/resources/static/udev/60-kaleidoscope.rules
  '';

  meta = with lib; {
    description = "A graphical configurator for Kaleidoscope-powered keyboards";
    homepage = "https://github.com/keyboardio/Chrysalis";
    license = licenses.gpl3;
    maintainers = with maintainers; [ aw ];
    platforms = [ "x86_64-linux" ];
  };
}
