{ stdenv, fetchurl, unzip, makeDesktopItem, mono }:

stdenv.mkDerivation rec {
  name = "keepass-${version}";
  version = "2.28";

  src = fetchurl {
    url = "mirror://sourceforge/keepass/KeePass-${version}.zip";
    sha256 = "0rlll6qriflaibqpw9qqfgqqr7cvhl404c3ph6n2i22j7xn5mizh";
  };

  sourceRoot = ".";

  phases = [ "unpackPhase" "installPhase" ];

  desktopItem = makeDesktopItem {
    name = "keepass";
    exec = "keepass";
    comment = "Password manager";
    desktopName = "Keepass";
    genericName = "Password manager";    
    categories = "Application;Other;";
  };


  installPhase = ''
    mkdir -p "$out/bin"
    echo "${mono}/bin/mono $out/KeePass.exe" > $out/bin/keepass
    chmod +x $out/bin/keepass
    echo $out
    cp -r ./* $out/
    mkdir -p "$out/share/applications"
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  buildInputs = [ unzip ];

  meta = {
    description = "GUI password manager with strong cryptography";
    homepage = http://www.keepass.info/;
    maintainers = with stdenv.lib.maintainers; [amorsillo];
    platforms = with stdenv.lib.platforms; all;
    license = stdenv.lib.licenses.gpl2;
  };
}
