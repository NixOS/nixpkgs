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
  libglvnd,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "muse-sounds-manager";
  version = "2.0.3.659";

  # Use web.archive.org since upstream does not provide a stable (versioned) URL.
  # To see if there are new versions on the Web Archive, visit
  # http://web.archive.org/cdx/search/cdx?url=https://muse-cdn.com/Muse_Sounds_Manager_x64.tar.gz
  # then replace the date in the URL below with date when the SHA1
  # changes (currently D7XUTZISBSZLTPDZISV4E62Q2HVYFQAX) and replace
  # the version above with the version in the settings of muse-sounds-manager.
  src = fetchurl {
    url = "https://web.archive.org/web/20241208182810/https://muse-cdn.com/Muse_Sounds_Manager_x64.tar.gz";
    hash = "sha256-tZhmFYEKc86/H/IBqpnnT2e7Vvn42BSTD95zqpO9aC4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
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
    libglvnd
    openssl
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt $out/bin $out/share/applications
    mv bin $out/opt/muse-sounds-manager
    ln -s $out/opt/muse-sounds-manager/muse-sounds-manager $out/bin/
    mv res/icons $out/share/
    mv res/muse-sounds-manager.desktop $out/share/applications/

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
