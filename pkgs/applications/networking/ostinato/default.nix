{ stdenv, fetchFromGitHub, fetchurl, qmake4Hook, makeDesktopItem
, qt4, protobuf, libpcap, wireshark, gzip, diffutils, gawk
}:

stdenv.mkDerivation rec {
  name    = "ostinato-${version}";
  version = "0.8";

  src = fetchFromGitHub  {
    owner  = "pstavirs";
    repo   = "ostinato";
    rev    = "v${version}";
    sha256 = "1b5a5gypcy9i03mj6md3lkrq05rqmdyhfykrr1z0sv8n3q48xca3";
  };

  ostinatoIcon = fetchurl {
    url = "http://ostinato.org/images/site-logo.png";
    sha256 = "f5c067823f2934e4d358d76f65a343efd69ad783a7aeabd7ab4ce3cd03490d70";
  };

  buildInputs = [ qt4 protobuf libpcap ];

  nativeBuildInputs = [ qmake4Hook ];

  patches = [ ./drone_ini.patch ];

  desktopItem = makeDesktopItem {
    type          = "application";
    name          = "ostinato";
    desktopName   = "Ostinato";
    genericName   = "Packet/Traffic Generator and Analyzer";
    comment       = "Network packet and traffic generator and analyzer with a friendly GUI";
    categories    = "Network";
    terminal      = "false";
    startupNotify = "true";
    exec          = "$out/bin/ostinato";
    icon          =  ostinatoIcon;
    extraEntries  = ''
      GenericName[it]=Generatore ed Analizzatore di pacchetti di rete
      Comment[it]=Generatore ed Analizzatore di pacchetti di rete con interfaccia amichevole
    '';
  };

  postInstall = ''
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/

    cat > $out/bin/ostinato.ini <<EOF
    WiresharkPath=${wireshark}/bin/wireshark
    TsharkPath=${wireshark}/bin/tshark
    GzipPath=${gzip}/bin/gzip
    DiffPath=${diffutils}/bin/diff
    AwkPath=${gawk}/bin/awk
    EOF
  '';

  meta = with stdenv.lib; {
    description = "A packet traffic generator and analyzer";
    homepage    = http://ostinato.org;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ rick68 ];
    platforms   = with platforms; linux ++ darwin ++ cygwin;
  };
}
