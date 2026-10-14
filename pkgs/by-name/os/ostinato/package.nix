{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  qt5,
  copyDesktopItems,
  makeDesktopItem,
  protobuf_21,
  libpcap,
  wireshark,
  gzip,
  diffutils,
  gawk,
  libnl,
}:
let
  protobuf = protobuf_21;

  ostinatoIcon = fetchurl {
    url = "https://ostinato.org/images/site-logo.png";
    hash = "sha256-9cBngj8pNOTTWNdvZaND79aa14OnrqvXq0zjzQNJDXA=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ostinato";
  version = "1.3.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pstavirs";
    repo = "ostinato";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/fPUxGeh5Cc3rb+1mR0chkiFPw5m+O6KtWDvzLn0iYo=";
  };

  buildInputs = [
    qt5.qtbase
    protobuf
    libpcap
    qt5.qtscript
    libnl
  ];

  nativeBuildInputs = [
    copyDesktopItems
    qt5.qmake
    qt5.wrapQtAppsHook
    qt5.qtscript
    protobuf
  ];

  patches = [ ./drone_ini.patch ];
  prePatch = ''
    sed -i 's|/usr/include/libnl3|${libnl.dev}/include/libnl3|' server/drone.pro
  '';

  desktopItems = lib.singleton (makeDesktopItem {
    name = "ostinato";
    desktopName = "Ostinato";
    genericName = "Packet/Traffic Generator and Analyzer";
    comment = "Network packet and traffic generator and analyzer with a friendly GUI";
    categories = [ "Network" ];
    startupNotify = true;
    exec = "@out@/bin/ostinato";
    icon = ostinatoIcon;
    extraConfig = {
      "GenericName[it]" = "Generatore ed Analizzatore di pacchetti di rete";
      "Comment[it]" = "Generatore ed Analizzatore di pacchetti di rete con interfaccia amichevole";
    };
  });

  preFixup = ''
    substituteInPlace $out/share/applications/ostinato.desktop \
      --subst-var out

    cat > $out/bin/ostinato.ini <<EOF
    WiresharkPath=${wireshark}/bin/wireshark
    TsharkPath=${wireshark}/bin/tshark
    GzipPath=${gzip}/bin/gzip
    DiffPath=${diffutils}/bin/diff
    AwkPath=${gawk}/bin/awk
    EOF
  '';

  # `cd common; qmake ostproto.pro; make pdmlreader.o`:
  # pdmlprotocol.h:23:25: fatal error: protocol.pb.h: No such file or directory
  enableParallelBuilding = false;

  meta = {
    description = "Packet traffic generator and analyzer";
    homepage = "https://ostinato.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ rick68 ];
    platforms = with lib.platforms; linux ++ darwin ++ cygwin;
  };
})
