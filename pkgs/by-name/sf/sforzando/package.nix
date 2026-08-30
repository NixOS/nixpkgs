{
  lib,
  stdenv,
  fetchzip,
  dpkg,
  nixosTests,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  cairo,
  curl,
  glib,
  gtk3,
  gtkmm3,
  libpulseaudio,
  pango,
  libxcb-util,
  zenity,
}:

let
  version = "1.982";
in
stdenv.mkDerivation {
  pname = "sforzando";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://sforzando.s3.us-east-1.amazonaws.com/LINUX_plogue-sforzando_${version}_x86_64.zip";
    hash = "sha256-Qcwv5DgReNxA68CWosvIwZkhDAxnc5/A15lmlc/Mr3M=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    cairo
    curl
    glib
    gtk3
    gtkmm3
    libpulseaudio
    pango
    libxcb-util
  ];

  unpackPhase = ''
    runHook preUnpack
    for deb in $src/*.deb; do
      dpkg-deb -x "$deb" pkgs
    done
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Plogue"
    cp -r pkgs/opt/Plogue/Aria      "$out/Plogue/"
    cp -r pkgs/opt/Plogue/sforzando "$out/Plogue/"
    cp -r pkgs/opt/Plogue/TableWarp2 "$out/Plogue/"

    # Patch hardcoded /opt/Plogue paths inside the .config JSON files.
    # The Aria engine reads these to locate libAria.so and its resources.
    sed -i "s|/opt/Plogue/Aria|$out/Plogue/Aria|g"           "$out/Plogue/Aria/.config"
    sed -i "s|/opt/Plogue/sforzando|$out/Plogue/sforzando|g" "$out/Plogue/sforzando/.config"

    mkdir -p "$out/lib/vst3"
    cp -r pkgs/usr/lib/vst3/sforzando.vst3 "$out/lib/vst3/"

    mkdir -p "$out/lib/clap"
    cp pkgs/usr/lib/clap/sforzando.clap "$out/lib/clap/"

    mkdir -p "$out/share/applications" "$out/share/icons/hicolor/256x256/apps"
    cp pkgs/usr/share/applications/plogue-sforzando.desktop \
       "$out/share/applications/"
    cp pkgs/usr/share/icons/hicolor/256x256/apps/plogue-sforzando.png \
       "$out/share/icons/hicolor/256x256/apps/"
    substituteInPlace "$out/share/applications/plogue-sforzando.desktop" \
      --replace 'Exec=/opt/Plogue/sforzando/sforzando' "Exec=$out/bin/sforzando"

    mkdir -p "$out/bin"
    makeWrapper "$out/Plogue/sforzando/sforzando" "$out/bin/sforzando" \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}

    runHook postInstall
  '';

  # Teach autoPatchelfHook to find libAria.so when patching the VST3/CLAP plugins.
  preFixup = ''
    addAutoPatchelfSearchPath "$out/Plogue/Aria"
  '';

  passthru.tests = {
    inherit (nixosTests) sforzando;
  };

  meta = {
    description = "Free, highly SFZ 2.0 compliant sample player";
    homepage = "https://plogue.com/products/sforzando.html";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ Incand ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "sforzando";
  };
}
