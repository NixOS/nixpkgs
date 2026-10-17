{
  buildFHSEnv,
  dbus,
  fetchzip,
  fontconfig,
  freetype,
  glib,
  lib,
  libGL,
  xkeyboard_config,
  libxrender,
  libxi,
  libxext,
  libx11,
  libsm,
  libice,
  libxcb,
  zlib,
}:

buildFHSEnv (finalAttrs: {
  pname = "kingstvis";
  version = "3.6.6";

  src = fetchzip {
    url = "http://res.kingst.site/kfs/KingstVIS_v${finalAttrs.version}.tar.gz";
    hash = "sha256-41tIOUaPOkyLAowf0M+hnZC6b5wVKVAD/DTjnE7nbOQ=";
  };

  targetPkgs = pkgs: [
    dbus
    fontconfig
    freetype
    glib
    libGL
    xkeyboard_config
    libice
    libsm
    libx11
    libxext
    libxi
    libxrender
    libxcb
    zlib
  ];

  extraInstallCommands = ''
    install -Dvm644 ${finalAttrs.src}/Driver/99-Kingst.rules \
      $out/lib/udev/rules.d/99-Kingst.rules
  '';

  runScript = "${finalAttrs.src}/KingstVIS";

  meta = {
    description = "Kingst Virtual Instruments Studio, software for logic analyzers";
    homepage = "http://www.qdkingst.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.luisdaranda ];
    platforms = [ "x86_64-linux" ];
  };
})
