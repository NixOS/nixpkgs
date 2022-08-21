{ lib
, stdenv
, fetchFromGitHub

, autoreconfHook
, pkg-config
, intltool

, glib
, gtk2
, dbus-glib
, libappindicator-gtk2
, libnotify
, python3
, runtimeShell
}:

stdenv.mkDerivation rec {
  pname = "osdlyrics";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "osdlyrics";
    repo = "osdlyrics";
    rev = version;
    sha256 = "sha256-VxLNaNe4hFwgSW4JEF1T4BWC2NwiOgfwVGiAIOszfGE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    intltool
  ];

  buildInputs = [
    glib
    gtk2
    dbus-glib
    libappindicator-gtk2
    libnotify
    python3.pkgs.wrapPython
    (python3.withPackages (pp: with pp; [
      chardet
      dbus-python
      future
      pycurl
      pygobject3
    ]))
  ];

  postFixup = ''
    extractExecLine() {
      serviceFile=$1
      program=$2

      execLine=$(grep --only-matching --perl-regexp 'Exec=\K(.+)' "$serviceFile")
      echo "#!${runtimeShell}" > "$program"
      echo "exec $execLine" >> "$program"
      chmod +x "$program"

      substituteInPlace "$serviceFile" \
        --replace "Exec=$execLine" "Exec=$program"
    }

    # Extract the exec line into a separate program so that it can be wrapped.
    mkdir -p "$out/libexec/osdlyrics/"
    for svcFile in "$out/share/dbus-1/services"/*; do
      svc=$(basename "$svcFile" ".service")
      if grep "python" "$svcFile"; then
        extractExecLine "$svcFile" "$out/libexec/osdlyrics/$svc"
      fi
    done

    for p in "$out/bin/osdlyrics-create-lyricsource" "$out/bin/osdlyrics-daemon" "$out/libexec/osdlyrics"/*; do
      wrapProgram "$p" \
        --prefix PYTHONPATH : "$out/${python3.sitePackages}"
    done
  '';

  meta = with lib; {
    description = "Standalone lyrics fetcher/displayer";
    homepage = "https://github.com/osdlyrics/osdlyrics";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
