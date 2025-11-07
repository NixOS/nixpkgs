{
  alsa-lib,
  autoPatchelfHook,
  copyDesktopItems,
  fetchurl,
  fetchzip,
  lib,
  libGL,
  libXScrnSaver,
  libXcursor,
  libXi,
  libXinerama,
  libXrandr,
  libXxf86vm,
  libpulseaudio,
  libudev0-shim,
  makeDesktopItem,
  nix-update-script,
  stdenv,
  vulkan-loader,
  pname ? "daggerfall-unity",
  includeUnfree ? false,
}:
let
  docFiles = [
    (fetchurl {
      url = "https://www.dfworkshop.net/static_files/daggerfallunity/Daggerfall%20Unity%20Manual.pdf";
      hash = "sha256-FywlD0K5b4vUWzyzANlF9575XTDLivbsym7F+qe0Dm8=";
      name = "Daggerfall Unity Manual.pdf";
      meta.license = lib.licenses.mit;
    })
  ]
  ++ lib.optionals includeUnfree [
    (fetchurl {
      url = "https://cdn.bethsoft.com/bethsoft.com/manuals/Daggerfall/daggerfall-en.pdf";
      hash = "sha256-24KSP/E7+KvSRTMDq63NVlVWTFZnQj1yya8wc36yrC0=";
      meta.license = lib.licenses.unfree;
    })
  ];
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  version = "1.1.1";

  src = fetchzip {
    url = "https://github.com/Interkarma/daggerfall-unity/releases/download/v${finalAttrs.version}/dfu_linux_64bit-v${finalAttrs.version}.zip";
    hash = "sha256-JuhhVLpREM9e9UtlDttvFUhHWpH7Sh79OEo1OM4ggKA=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    libGL
    libXScrnSaver
    libXcursor
    libXi
    libXinerama
    libXrandr
    libXxf86vm
    libpulseaudio
    libudev0-shim
    vulkan-loader
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents "$out/bin" "$out/share/doc" "$out/share/pixmaps/"
    cp --recursive * "$out"
    ln --symbolic "../${finalAttrs.meta.mainProgram}" "$out/bin/"
    ln --symbolic ../../DaggerfallUnity_Data/Resources/UnityPlayer.png "$out/share/pixmaps/"

    ${lib.strings.concatMapStringsSep "\n" (file: ''
      cp "${file}" "$out/share/doc/${file.name}"
    '') docFiles}

    runHook postInstall
  '';

  appendRunpaths = [ (lib.makeLibraryPath finalAttrs.buildInputs) ];

  desktopItems = [
    (makeDesktopItem {
      name = "daggerfall-unity";
      desktopName = "Daggerfall Unity";
      comment = finalAttrs.meta.description;
      icon = "UnityPlayer";
      exec = finalAttrs.meta.mainProgram;
      categories = [ "Game" ];
    })
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v(\\d+(\\.\\d+)*)$" ];
  };

  meta = {
    homepage = "https://www.dfworkshop.net/";
    description = "Open source recreation of Daggerfall in the Unity engine";
    longDescription = ''
      Daggerfall Unity is an open source recreation of Daggerfall in the Unity engine created by Daggerfall Workshop.

      Experience the adventure and intrigue of Daggerfall with all of its original charm along with hundreds of fixes, quality of life enhancements, and extensive mod support.

      Includes Daggerfall Unity manual.

      ${lib.optionalString includeUnfree ''
        This "unfree" variant also includes the manual for Daggerfall (the game, not the open source engine).
      ''}
    '';
    changelog = "https://github.com/Interkarma/daggerfall-unity/releases/tag/v${finalAttrs.version}";
    mainProgram = "DaggerfallUnity.x86_64";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ l0b0 ];
    platforms = [ "x86_64-linux" ];
  };
})
