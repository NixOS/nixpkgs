{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  fontconfig,
  freetype,
  libGL,
  libpulseaudio,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pocketbard";
  version = "3.2.0-240";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://downloads.pocketbard.app/desktop/channels/stable/pocketbard_${finalAttrs.version}_amd64.deb";
    hash = "sha256-SlLNPh8Nb27bquw6r+oQGmY9NMN0lVsUeBmU1M/JFK0=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  # Bundles its own JRE (Compose Multiplatform / Conveyor); these are the
  # external libs the runtime and AWT/Skia bits link against.
  buildInputs = [
    alsa-lib
    fontconfig
    freetype
    libGL
    libx11
    libxext
    libxi
    libxrender
    libxtst
    zlib
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share
    cp -r usr/lib/* $out/lib/
    cp -r usr/share/* $out/share/

    # libwwisebridge.so dlopen()s its PulseAudio backend by bare soname at
    # runtime (no DT_NEEDED/RPATH for it at all), so autoPatchelf can't fix
    # this up; without libpulse.so.0 on LD_LIBRARY_PATH the dlopen fails and
    # Wwise segfaults calling through the resulting null function pointer.
    makeWrapper $out/lib/pocketbard/bin/pocketbard $out/bin/pocketbard \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libpulseaudio ]}

    substituteInPlace $out/share/applications/com.pocketbard.pocketbard.desktop \
      --replace-fail /usr/lib/pocketbard/bin/pocketbard $out/bin/pocketbard

    runHook postInstall
  '';

  meta = {
    description = "Interactive music and ambience for your tabletop RPG sessions";
    homepage = "https://pocketbard.app";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ Stormageddon37 ];
    mainProgram = "pocketbard";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
