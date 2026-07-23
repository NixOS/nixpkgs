{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  unzip,
  jre,
  libGL,
  libglvnd,
  libx11,
  libxext,
  libxcursor,
  libxrandr,
  libxi,
  libxxf86vm,
  libxinerama,
  libpulseaudio,
  udev,
  zenity,
  yad,
  which,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mixing-station";
  version = "2.9.1";

  src = fetchzip {
    url = "https://mixingstation.app/backend/api/web/download/archive/mixing-station-pc/update/${finalAttrs.version}";
    name = "mixing-station-${finalAttrs.version}.zip";
    extension = "zip";
    hash = "sha256-tyoagT21lIT0kIL9RZT1qQ7Aa7E3WAfmdsqvqc7iEGU=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  dontBuild = true;

  installPhase =
    let
      runtimeLibs = lib.makeLibraryPath [
        libGL
        libglvnd
        libx11
        libxext
        libxcursor
        libxrandr
        libxi
        libxxf86vm
        libxinerama
        libpulseaudio
        udev
      ];
      dialogTools = [
        zenity
        yad
        which
      ];
    in
    ''
      runHook preInstall
      install -Dm644 mixing-station-desktop.jar \
        "$out/share/mixing-station/mixing-station-desktop.jar"
      makeWrapper "${jre}/bin/java" "$out/bin/mixing-station" \
            --add-flags "-Dawt.useSystemAAFontSettings=gasp" \
            --add-flags "-jar $out/share/mixing-station/mixing-station-desktop.jar" \
            --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
            --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib" \
            --suffix PATH : "${lib.makeBinPath dialogTools}"
      runHook postInstall
    '';

  meta = {
    description = "Remote control app for digital audio mixers (XAir, X32, dLive, etc.)";
    homepage = "https://mixingstation.app";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "mixing-station";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ korny666 ];
  };
})
