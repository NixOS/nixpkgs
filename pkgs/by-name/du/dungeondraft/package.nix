{
  alsa-lib,
  dpkg,
  lib,
  libGL,
  libkrb5,
  libpulseaudio,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxrandr,
  libxrender,
  makeWrapper,
  requireFile,
  stdenv,
  udev,
  zenity,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "dungeondraft";
  version = "1.2.0.1";

  src = requireFile {
    name = "Dungeondraft-${finalAttrs.version}-Linux64.deb";
    url = "https://dungeondraft.net/";
    hash = "sha256-UvvUCQ1RkhwBPMet/zD0JjI7DPbF4ixzOX85Fi3v/BE=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    libGL
    libkrb5
    libpulseaudio
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxrandr
    libxrender
    udev
    zlib
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -R opt/Dungeondraft $out/share/dungeondraft
    cp -R usr/share/. $out/share

    makeWrapper $out/share/dungeondraft/Dungeondraft.x86_64 $out/bin/dungeondraft \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}

    substituteInPlace $out/share/applications/Dungeondraft.desktop \
      --replace-fail /opt/Dungeondraft/Dungeondraft.x86_64 $out/bin/dungeondraft \
      --replace-fail /opt/Dungeondraft $out/share/dungeondraft

    runHook postInstall
  '';

  # Setting the interpreter before the rpath causes a layout issue
  postFixup = ''
    patchelf --set-rpath ${lib.makeLibraryPath finalAttrs.buildInputs} $out/share/dungeondraft/Dungeondraft.x86_64
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} $out/share/dungeondraft/Dungeondraft.x86_64
    find $out/share/dungeondraft -name "*.so" -exec patchelf --set-rpath ${lib.makeLibraryPath finalAttrs.buildInputs} {} +
  '';

  meta = {
    homepage = "https://dungeondraft.net/";
    description = "Dungeondraft is a tabletop encounter map creation tool designed to draw aesthetic maps without the typical frustrations and time investment.";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ sgme ];
    mainProgram = "dungeondraft";
  };
})
