{ lib, mkDerivation, fetchFromGitHub, fetchurl, qmake, makeDesktopItem
, qtbase, qtscript, protobuf, libpcap, wireshark, gzip, diffutils, gawk
, libnl
, copyDesktopItems
}:

mkDerivation rec {
  pname = "ostinato";
  version = "1.3.0";

  src = fetchFromGitHub  {
    owner  = "pstavirs";
    repo   = "ostinato";
    rev    = "v${version}";
    sha256 = "sha256-/fPUxGeh5Cc3rb+1mR0chkiFPw5m+O6KtWDvzLn0iYo=";
  };

  ostinatoIcon = fetchurl {
    url = "https://ostinato.org/images/site-logo.png";
    sha256 = "f5c067823f2934e4d358d76f65a343efd69ad783a7aeabd7ab4ce3cd03490d70";
  };

  buildInputs = [ qtbase protobuf libpcap qtscript libnl ];

  nativeBuildInputs = [
    copyDesktopItems
    qmake
  ];

  patches = [ ./drone_ini.patch ];
  prePatch = ''
    sed -i 's|/usr/include/libnl3|${libnl.dev}/include/libnl3|' server/drone.pro
  '';

  desktopItems = lib.singleton (makeDesktopItem {
    name          = "ostinato";
    desktopName   = "Ostinato";
    genericName   = "Packet/Traffic Generator and Analyzer";
    comment       = "Network packet and traffic generator and analyzer with a friendly GUI";
    categories    = [ "Network" ];
    startupNotify = true;
    exec          = "@out@/bin/ostinato";
    icon          =  ostinatoIcon;
    extraConfig   = {
      "GenericName[it]" = "Generatore ed Analizzatore di pacchetti di rete";
      "Comment[it]"     = "Generatore ed Analizzatore di pacchetti di rete con interfaccia amichevole";
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

  meta = with lib; {
    description = "Packet traffic generator and analyzer";
    homepage    = "https://ostinato.org/";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ rick68 ];
    platforms   = with platforms; linux ++ darwin ++ cygwin;
  };
}
