{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  fontconfig,
  zlib,
  icu,
  libX11,
  libXext,
  libXi,
  libXrandr,
  libICE,
  libSM,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "muse-sounds-manager";
  version = "1.1.0.587";

  # Use web.archive.org since upstream does not provide a stable (versioned) URL.
  # To see if there are new versions on the Web Archive, visit
  # http://web.archive.org/cdx/search/cdx?url=https://muse-cdn.com/Muse_Sounds_Manager_Beta.deb
  # then replace the date in the URL below with date when the SHA1
  # changes (currently A3NX3WHFZWXCHZVME2ABUL2VRENTWOD5) and replace
  # the version above with the version in the .deb metadata (or in the
  # settings of muse-sounds-manager).
  src = fetchurl {
    url = "https://web.archive.org/web/20240826143936/https://muse-cdn.com/Muse_Sounds_Manager_Beta.deb";
    hash = "sha256-wzZAIjme1cv8+jMLiKT7kUQvCb+UhsvOnLDV4hCL3hw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    fontconfig
    stdenv.cc.cc
    zlib
  ] ++ runtimeDependencies;

  runtimeDependencies = map lib.getLib [
    icu
    libX11
    libXext
    libXi
    libXrandr
    libICE
    libSM
    openssl
  ];

  unpackPhase = "dpkg -x $src .";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/* opt $out/
    substituteInPlace $out/bin/muse-sounds-manager --replace-fail /opt/ $out/opt/

    runHook postInstall
  '';

  meta = {
    description = "Manage Muse Sounds (Muse Hub) libraries for MuseScore";
    homepage = "https://musescore.org/";
    license = lib.licenses.unfree;
    mainProgram = "muse-sounds-manager";
    maintainers = with lib.maintainers; [ orivej ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
