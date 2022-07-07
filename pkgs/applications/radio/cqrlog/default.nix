{ lib
, stdenv
, fetchFromGitHub
, fpc
, lazarus
, atk
, cairo
, gdk-pixbuf
, glib
, gtk2-x11
, libX11
, pango
, hamlib
, mysql57
, tqsl
, xdg-utils
, xplanet
, autoPatchelfHook
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "cqrlog";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "ok2cqr";
    repo = "cqrlog";
    rev = "v${version}";
    sha256 = "0zzcg0bl6mq4wfifj998x9x09w8sigbh46synpqx034fpr0swyhb";
  };

  # Adds the possiblity to change the lazarus directory,
  # otherwise, we would get error : "directory lcl not found"
  patches = [ ./fix-makefile-lazarusdir.patch ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace @Lazarusdir@ "${lazarus}/share/lazarus" \
      --replace /usr ""
    substituteInPlace src/fTRXControl.pas \
      --replace "/usr/bin/rigctld" "${hamlib}/bin/rigctld"
    substituteInPlace src/fCallAttachment.pas \
      --replace "/usr/bin/xdg-open" "${xdg-utils}/bin/xdg-open"
    substituteInPlace src/fRotControl.pas \
      --replace "/usr/bin/rotctld" "${hamlib}/bin/rotctld"
    substituteInPlace src/fPreferences.pas \
      --replace "/usr/bin/rigctld" "${hamlib}/bin/rigctld" \
      --replace "/usr/bin/rotctld" "${hamlib}/bin/rotctld" \
      --replace "/usr/bin/xplanet" "${xplanet}/bin/xplanet"
    substituteInPlace src/fLoTWExport.pas \
      --replace "/usr/bin/tqsl" "${tqsl}/bin/tqsl"
    substituteInPlace src/dUtils.pas \
      --replace "/usr/bin/xplanet" "${xplanet}/bin/xplanet" \
      --replace "/usr/bin/rigctld" "${hamlib}/bin/rigctld"
    # Order is important
    substituteInPlace src/dData.pas \
      --replace "/usr/bin/mysqld_safe" "${mysql57}/bin/mysqld_safe" \
      --replace "/usr/bin/mysqld" "${mysql57}/bin/mysqld"

    # To be fail when I need to patch a new hardcoded binary
    ! grep -C src -RC0 "/usr"
  '';

  nativeBuildInputs = [ lazarus fpc autoPatchelfHook wrapGAppsHook ];
  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk2-x11
    libX11
    pango
  ];
  propagatedBuildInputs = [
    hamlib
    mysql57
    tqsl
    xdg-utils
    xplanet
  ];

  makeFlags = [
    "FPC=fpc"
    "PP=fpc"
    "DESTDIR=$(out)"
  ];

  postFixup = ''
    libmysqlclient=$(find "${mysql57}/lib" -name "libmysqlclient.so.*" | tail -n1)
    patchelf --add-needed "$libmysqlclient" "$out/bin/.cqrlog-wrapped"
  '';

  meta = with lib; {
    description = "Linux logging program for amateur radio operators";
    homepage = "https://www.cqrlog.com/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
