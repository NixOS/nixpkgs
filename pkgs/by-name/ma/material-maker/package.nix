{
  lib,
  stdenvNoCC,
  fetchzip,
  fetchurl,
  nix-update-script,

  # build deps
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  undmg,

  # runtime deps
  libGL,
  libGLU,
  libX11,
  libXcursor,
  libXext,
  libXfixes,
  libXi,
  libXinerama,
  libXrandr,
  libXrender,
  alsa-lib,
  libpulseaudio,
  udev,
}:
let
  toUnderscore = v: lib.replaceStrings [ "." ] [ "_" ] v;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "material-maker";
  version = "1.3";

  src =
    if stdenvNoCC.isLinux && stdenvNoCC.isx86_64 then
      fetchzip {
        url = "https://github.com/RodZill4/material-maker/releases/download/${finalAttrs.version}/material_maker_${toUnderscore finalAttrs.version}_linux.tar.gz";
        hash = "sha256-WEu5gVfnswB5zYzu3leOL+hKOBzJbn48gHQKshlfOh4=";
      }
    else if stdenvNoCC.isDarwin then
      fetchurl {
        url = "https://github.com/RodZill4/material-maker/releases/download/${finalAttrs.version}/material_maker_${toUnderscore finalAttrs.version}.dmg";
        hash = "sha256-D4jPQEOKws2JFczh0K55mR08jIBMU6jOFOm6TyFxnt8=";
      }
    else
      throw "unsupported platform";

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ] ++ lib.optionals stdenvNoCC.isDarwin [ undmg ];

  sourceRoot = ".";

  buildInputs = [
    libGL
    libGLU
    libX11
    libXcursor
    libXext
    libXfixes
    libXi
    libXinerama
    libXrandr
    libXrender
  ];

  desktopItems = makeDesktopItem {
    name = "material-maker";
    exec = "material-maker";
    icon = "material-maker";
    genericName = "Procedural texture generation and 3D model painting tool";
    desktopName = "Material Maker";
    comment = "Generate textures procedurally for use in PBR engines and paint 3D models";
    terminal = false;
    categories = [
      "Graphics"
      "3DGraphics"
    ];
    keywords = [
      "material"
      "textures"
      "paint"
      "3d"
    ];
  };

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenvNoCC.isLinux ''
      install -D -m 755 $src/material_maker.x86_64 $out/opt/material-maker
      install -D -m 644 $src/material_maker.pck $out/opt/material-maker.pck

      cp -r $src/{library,nodes,environments,meshes,export} $out/opt

      install -D -m 644 $src/doc/_static/icon.png -t $out/share/icons/hicolor/256x256/apps/

      mkdir -p $out/bin
      ln -s $out/opt/material-maker $out/bin/material-maker

      for output in $(getAllOutputNames); do
        if [ "$output" == "doc" ]; then
          cp -r $src/doc $out/share
          ln -s $doc/share/doc $out/opt/doc
        elif [ "$output" == "examples" ]; then
          cp -r $src/examples $examples
          ln -s $examples $out/opt/examples
        fi
      done
    ''
    + lib.optionalString stdenvNoCC.isDarwin ''
      mkdir -p $out/Applications
      cp -r ./material_maker.app $out/Applications
    ''
    + ''
      runHook postInstall
    '';

  outputs = [
    "out"
    "doc"
    "examples"
  ];

  runtimeDependencies = map lib.getLib [
    alsa-lib
    libpulseaudio
    udev
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.materialmaker.org/";
    description = "Tool based on Godot Engine that can be used to create textures procedurally and paint 3D models";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin ++ (lib.intersectLists lib.platforms.linux lib.platforms.x86_64);
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ aurreland ];
    mainProgram = "material-maker";
    outputsToInstall = [
      "out"
      "doc"
      "examples"
    ];
  };
})
