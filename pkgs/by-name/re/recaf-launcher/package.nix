{
  lib,
  stdenv,
  fetchurl,
  buildFHSEnv,
}:
let
  version = "0.8.1";
  jar = fetchurl {
    url = "https://github.com/Col-E/Recaf-Launcher/releases/download/${version}/recaf-gui-${version}.jar";
    hash = "sha256-RHsI8z/orwR9b9s+LrrOHpxpr82J6YOpnfik3dnlsvI=";
  };
in
buildFHSEnv {
  pname = "recaf-launcher";
  inherit version;

  targetPkgs =
    p: with p; [
      jar

      openjdk23
      xorg.libX11
      at-spi2-atk
      cairo
      gdk-pixbuf
      glib
      gtk3
      pango
      xorg.libXtst
      xorg.libX11
      xorg_sys_opengl
    ];

  runScript = "java -jar ${jar}";

  meta = {
    description = "Simple launcher for Recaf 4.X and above - a modern Java bytecode editor";
    homepage = "https://recaf.coley.software";
    changelog = "https://github.com/Col-E/Recaf-Launcher/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tudbut ];
    mainProgram = "recaf-launcher";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
