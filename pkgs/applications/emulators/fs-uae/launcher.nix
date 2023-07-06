{ lib
, stdenv
, fetchurl
, gettext
, python3
, wrapQtAppsHook
, fsuae
}:

stdenv.mkDerivation rec {
  pname = "fs-uae-launcher";
  version = "3.1.68";

  src = fetchurl {
    url = "https://fs-uae.net/files/FS-UAE-Launcher/Stable/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-42EERC2yeODx0HPbwr4vmpN80z6WSWi3WzJMOT+OwDA=";
  };

  nativeBuildInputs = [
    gettext
    python3
    wrapQtAppsHook
  ];

  buildInputs = with python3.pkgs; [
    pyqt5
    requests
    setuptools
  ];

  makeFlags = [ "prefix=$(out)" ];

  dontWrapQtApps = true;

  preFixup = ''
      wrapQtApp "$out/bin/fs-uae-launcher" --set PYTHONPATH "$PYTHONPATH" \
        --prefix PATH : ${lib.makeBinPath [ fsuae ]}
  '';

  meta = with lib; {
    homepage = "https://fs-uae.net";
    description = "Graphical front-end for the FS-UAE emulator";
    license = licenses.gpl2Plus;
    maintainers = with  maintainers; [ sander AndersonTorres ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}

