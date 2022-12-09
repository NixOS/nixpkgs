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
  version = "3.0.5";

  src = fetchurl {
    url = "https://fs-uae.net/stable/${version}/${pname}-${version}.tar.gz";
    sha256 = "1dknra4ngz7bpppwqghmza1q68pn1yaw54p9ba0f42zwp427ly97";
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

