{ lib
, stdenv
, fetchurl
, gettext
, makeWrapper
, python3
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
    makeWrapper
    python3
  ];

  buildInputs = with python3.pkgs; [
    pyqt5
    requests
    setuptools
  ];

  makeFlags = [ "prefix=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/fs-uae-launcher --set PYTHONPATH "$PYTHONPATH"
  '';

  meta = with lib; {
    homepage = "https://fs-uae.net";
    description = "Graphical front-end for the FS-UAE emulator";
    license = lib.licenses.gpl2Plus;
    maintainers = with  maintainers; [ sander AndersonTorres ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
