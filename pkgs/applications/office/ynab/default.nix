{ stdenv, fetchurl, innoextract, wineUnstable, writeScript, makeDesktopItem }:

let 
  version = "4.3.656";

  wrapped = stdenv.mkDerivation {
    name = "ynab-wrapped-${version}";

    /*
      There was an issue with url fetching, hence the dropbox link. 
      See <https://github.com/NixOS/nixpkgs/issues/6165>.
    */
    src = fetchurl {
      #url = "http://www.youneedabudget.com/CDNOrigin/download/ynab4/liveCaptive/Win/YNAB\%204_${version}_Setup.exe";
      url = "https://www.dropbox.com/s/1cbki88s4uejl60/YNAB4_${version}_Setup.exe?dl=0";
      sha256 = "1llcbmj3vg43lv7h4cgyijbl0vfj0jslj8jcsmqvvrb9jjmvm6ls";
    };

    buildInputs = [ innoextract ];

    unpackPhase = ''
      innoextract -e $src
    '';

    installPhase = ''
        mkdir -p $out/share/ynab $out/opt/ynab $out/bin 
        cp -a app/* $out/share/ynab
    '';
  };

  /*
    Automatically classify the application in proper menu category.

    Attempt at giving poper file association.

    The `%f` allow supported files such as `*.qfx` to be opened
    by the application. When the application is already running,
    the instance will handle the file. One can also drag files
    on the application's icon.
  */
  desktopItem = makeDesktopItem {
    desktopName = "YNAB 4";
    genericName = "Budget tool";
    name = "ynab";
    exec = "ynab %f";
    icon = "${wrapped}/share/ynab/assets/AppIcon-48.png";
    comment = "A proprietary budgeting software";
    type = "Application";
    categories = "Application;Office;Finance;";
    mimeType = stdenv.lib.concatStringsSep ";" [
      "application/vnd.intu.qfx"
      "application/x-qfx"
      "application/qif"
      "text/qif"
      "text/csv"
      "application/vnd.ynab.y4backup"
      "application/vnd.ynab.ymeta"
      "application/vnd.ynab.yfull"
      "application/vnd.ynab.ydiff"
      "application/vnd.ynab.ybsettings"
    ];
  };

  exposeDropboxScript = ./expose_linux_dropbox_to_wine.sh;

  /*
    Provide wine environement to the application without polluting
    the whole profile with all wine's files and executables.

    Adapt the expected file argument so that it points to the file
    through the `Z:\` drive using windows style paths.

    TODO: Opening a file with relative path does not work. Is
    that expected? Could be that wine does not adapt the current
    working directory so that it passes through `Z:\` or that
    this does not even work on windows. 
  */
  ynabWrapper = writeScript "ynab_wrapper.sh" ''
    export LD_LIBRARY_PATH=${wineUnstable}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
    export PATH=${wineUnstable}/bin''${PATH:+:$PATH}

    ${exposeDropboxScript}

    A1_FILE_PATH=$(echo -n "$1" | sed s?^/?Z\:/?g | tr '/' '\\\')

    echo "Adapted application arguments: =\"$A1_FILE_PATH\""

    wine ${wrapped}/share/ynab/YNAB\ 4.exe "$A1_FILE_PATH"
  '';

in 

stdenv.mkDerivation {
  name = "ynab-${version}";

  src = ./.;

  buildInputs = [ wineUnstable wrapped ];

  installPhase = ''
    mkdir -p $out/share/applications $out/bin 
    ln -sfT ${ynabWrapper} $out/bin/ynab
    cp -v "${desktopItem}/share/applications/"* "$out/share/applications"
  '';

  meta = {
    description = "A proprietary budgeting software";
    homepage = http://www.youneedabudget.com;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.unfree;
  };

}
