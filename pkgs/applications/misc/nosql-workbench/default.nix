{ appimageTools, lib, fetchurl, gtk3, gsettings-desktop-schemas, makeDesktopItem }:

# Based on https://gist.github.com/msteen/96cb7df66a359b827497c5269ccbbf94 and joplin-desktop nixpkgs.
let
  pname = "nosql-workbench";
  version = "3.2.1";
  name = "${pname}-${version}";

  src = fetchurl {
    name = pname;
    url = "https://s3.amazonaws.com/nosql-workbench/NoSQL%20Workbench-linux-x86_64-${version}.AppImage";
    sha256 = "c8qX5TTpocHIhv8Co6PXDt65PJLO6IItsIBXnASt5pY=";
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  desktopItem = makeDesktopItem {
    name = "NoSQL Workbench";
    exec = "nosql-workbench";
    comment = "NoSQL Workbench for Amazon DynamoDB is a cross-platform client-side application for modern database development and operations and is available for Windows and macOS.";
    desktopName = "NoSQL Workbench";
    genericName = "DB UI";
    categories = "Development";
  };

in
appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    cp -r ${appimageContents}/usr/share/icons/ $out/share/

  '';

  # below information from https://repology.org/project/nosql-workbench/information
  meta = with lib; {
    description = "NoSQL Workbench for Amazon DynamoDB is a cross-platform client-side application for modern database development and operations and is available for Windows and macOS";
    homepage = "https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/workbench.html";
    platforms = [ "x86_64-linux" ];
    license = {
      fullName = "NoSQL Workbench License Agreement";
      url = "https://aws.amazon.com/nosql/nosql-workbench-license/";
      free = false;
    };
    maintainers = with maintainers; [ johnrichardrinehart ];
  };
}
