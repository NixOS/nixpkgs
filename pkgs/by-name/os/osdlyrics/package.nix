{
  lib,
  stdenv,
  fetchFromGitHub,

  autoreconfHook,
  gobject-introspection,
  intltool,
  pkg-config,
  wrapGAppsNoGuiHook,

  glib,
  gtk2,
  dbus-glib,
  libappindicator-gtk2,
  libnotify,
  python3,
  runtimeShell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osdlyrics";
  version = "0.5.15";

  src = fetchFromGitHub {
    owner = "osdlyrics";
    repo = "osdlyrics";
    rev = finalAttrs.version;
    hash = "sha256-4jEF1LdMwaLNF6zvzAuGW8Iu4dzhrFLutX69LwSjTAI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gobject-introspection
    intltool
    pkg-config
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    glib
    gtk2
    dbus-glib
    libappindicator-gtk2
    libnotify
    python3.pkgs.wrapPython
    (python3.withPackages (
      pp: with pp; [
        chardet
        dbus-python
        pycurl
        pygobject3
      ]
    ))
  ];

  dontWrapGApps = true;

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
        ''${gappsWrapperArgs[@]} \
        --prefix PYTHONPATH : "$out/${python3.sitePackages}"
    done
  '';

  meta = {
    description = "Standalone lyrics fetcher/displayer";
    homepage = "https://github.com/osdlyrics/osdlyrics";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pedrohlc ];
    platforms = lib.platforms.linux;
  };
})
