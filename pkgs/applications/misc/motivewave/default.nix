{
  lib,
  stdenv,
  dpkg,
  makeWrapper,
  autoPatchelfHook,
  jdk11,
  gtk3,
  glib,
  xorg,
  alsa-lib,
  makeDesktopItem,
  requireFile,
  ffmpeg-full,
  libGL,
}:
let
  version = "6.9.10";

  desktopItem = makeDesktopItem {
    name = "motivewave";
    exec = "motivewave";
    icon = "motivewave";
    desktopName = "MotiveWave";
    genericName = "Trading Platform";
    categories = [
      "Office"
      "Finance"
    ];
  };

  runtimeLibs = [
    jdk11
    gtk3
    glib
    xorg.libXtst
    xorg.libXi
    xorg.libXxf86vm
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXrandr
    alsa-lib
    ffmpeg-full
    libGL
  ];
in
stdenv.mkDerivation {
  pname = "motivewave";
  inherit version;

  src = requireFile {
    name = "motivewave_6.9.10_amd64.deb";
    url = "https://www.motivewave.com/update/download.do?file_type=LINUX";
    message = ''
      Please download MotiveWave ${version} for Linux from:
      https://www.motivewave.com/update/download.do?file_type=LINUX

      After downloading, add it to the Nix store with:
      nix-store --add-fixed sha256 motivewave_6.9.10_amd64.deb
    '';
    sha256 = "17zicacd4jkzlrykjx3n60sz5vf525g33s1l33scl0707493i1yp";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = runtimeLibs;

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  dontBuild = true;
  dontConfigure = true;

  autoPatchelfIgnoreMissingDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}

    cp -r usr/share/* $out/share/

    mkdir -p $out/bin

    cp usr/share/motivewave/jre/bin/motivewave $out/bin/
    chmod +x $out/bin/motivewave

    makeWrapper $out/bin/motivewave $out/bin/.motivewave-wrapped \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs} \
      --prefix LD_LIBRARY_PATH : $out/share/motivewave/javafx \
      --prefix PATH : ${lib.makeBinPath [ jdk11 ]} \
      --set JAVA_HOME ${jdk11} \
      --set MOTIVEWAVE_HOME $out/share/motivewave

    mv $out/bin/.motivewave-wrapped $out/bin/motivewave

    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications/

    runHook postInstall
  '';

  meta = {
    description = "Advanced trading and technical analysis platform";
    homepage = "https://www.motivewave.com";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.qxrein ];
    mainProgram = "motivewave";
  };
}
