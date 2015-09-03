{ stdenv, fetchurl, buildDotnetPackage, makeWrapper, unzip, makeDesktopItem }:

buildDotnetPackage rec {
  baseName = "keepass";
  version = "2.30";

  src = fetchurl {
    url = "mirror://sourceforge/keepass/KeePass-${version}-Source.zip";
    sha256 = "1r792cikgvzj4hrxiv7xd3gx2zmn16dbh4inj2zi6ny0gchkqg2a";
  };

  sourceRoot = ".";

  buildInputs = [ unzip ];

  patches = [ ./keepass.patch ];

  preConfigure = "rm -rvf Build/*";

  desktopItem = makeDesktopItem {
    name = "keepass";
    exec = "keepass";
    comment = "Password manager";
    desktopName = "Keepass";
    genericName = "Password manager";    
    categories = "Application;Other;";
  };

  outputFiles = [ "Build/KeePass/Release/*" "Build/KeePassLib/Release/*" ];
  dllFiles = [ "KeePassLib.dll" ];
  exeFiles = [ "KeePass.exe" ];

  postInstall = ''
    mkdir -p "$out/share/applications"
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = {
    description = "GUI password manager with strong cryptography";
    homepage = http://www.keepass.info/;
    maintainers = with stdenv.lib.maintainers; [ amorsillo obadz ];
    platforms = with stdenv.lib.platforms; all;
    license = stdenv.lib.licenses.gpl2;
  };
}
