{
  alsa-lib,
  dpkg,
  lib,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxrandr,
  libxrender,
  libkrb5,
  libpulseaudio,
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

  buildInputs = [
    alsa-lib
    libGL
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxrandr
    libxrender
    libkrb5
    libpulseaudio
    udev
    zlib
  ];

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  sourceRoot = ".";
  unpackCmd = "dpkg-deb -x $curSrc .";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -R usr/share opt $out/
    runHook postInstall
  '';

  postFixup = ''
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} $out/opt/Dungeondraft/Dungeondraft.x86_64

    makeWrapper $out/opt/Dungeondraft/Dungeondraft.x86_64 $out/bin/dungeondraft \
      --prefix PATH : ${lib.makeBinPath [ zenity ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}

    substituteInPlace $out/share/applications/Dungeondraft.desktop \
      --replace-fail /opt/Dungeondraft/Dungeondraft.x86_64 $out/bin/dungeondraft \
      --replace-fail /opt/ $out/opt/
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
