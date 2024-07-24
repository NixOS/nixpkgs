{ buildFHSEnv
, dbus
, fetchzip
, fontconfig
, freetype
, glib
, lib
, libGL
, xkeyboard_config
, xorg
, zlib
}:

let
  name = "kingstvis";
  version = "3.6.1";
  src = fetchzip {
    url = "http://res.kingst.site/kfs/KingstVIS_v${version}.tar.gz";
    hash = "sha256-eZJ3RZWdmNx/El3Hh5kUf44pIwdvwOEkRysYBgUkS18=";
  };
in

buildFHSEnv {
  inherit name;

  targetPkgs = pkgs: (with pkgs; [
    dbus
    fontconfig
    freetype
    glib
    libGL
    xkeyboard_config
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.libxcb
    zlib
  ]);

  extraInstallCommands = ''
    install -Dvm644 ${src}/Driver/99-Kingst.rules \
      $out/lib/udev/rules.d/99-Kingst.rules
  '';

  runScript = "${src}/KingstVIS";

  meta = {
    description = "Kingst Virtual Instruments Studio, software for logic analyzers";
    homepage = "http://www.qdkingst.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.luisdaranda ];
    platforms = [ "x86_64-linux" ];
  };
}
