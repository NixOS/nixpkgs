{
  lib,
  stdenv,
  fetchurl,
  buildFHSEnv,
  gtk3,
  glib,
  gsettings-desktop-schemas,
  gtk2,
  libXtst,
  libXxf86vm,
  xorg,
  freetype,
  fontconfig,
  zlib,
  mesa,
  libGL,
  libdrm,
  libglvnd,
}:

let
  version = "1.10.0";
  pname = "defold";

  src = fetchurl {
    url = "https://github.com/defold/defold/releases/download/${version}/Defold-x86_64-linux.tar.gz";
    sha256 = "sha256-l2C4daXQWsDM3mmpcHSVzAOqrqsviU4C+U4kQywrAEk=";
  };

  runtimeLibs = [
    gtk3
    glib
    gsettings-desktop-schemas
    gtk2
    libXtst
    libXxf86vm
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXt
    xorg.libXfixes
    xorg.libXScrnSaver
    freetype
    fontconfig
    zlib
    mesa
    libGL
    libdrm
    libglvnd
  ];
in

buildFHSEnv {
  name = "${pname}";

  description = "A multi-platform game engine";

  runScript = "/opt/defold/Defold";

  targetPkgs = pkgs: runtimeLibs;

  # profile = ''
  #   export JAVA_TOOL_OPTIONS="--add-opens=java.base/sun.nio.fs=ALL-UNNAMED --add-opens=java.desktop/sun.awt.image=ALL-UNNAMED"
  # '';

  env = {
    "JAVA_TOOL_OPTIONS" =
      "--add-opens=java.base/sun.nio.fs=ALL-UNNAMED --add-opens=java.desktop/sun.awt.image=ALL-UNNAMED";
  };
  extraBuildCommands = ''
    mkdir -p $out/opt/defold
    tar -xzf ${src} --strip-components=1 -C $out/opt/defold
  '';

  meta = {
    description = "The Defold game engine";
    homepage = "https://defold.com/";
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ tombert ];
  };
}
