{ stdenv, lib, fetchFromGitHub, dconf, gettext, glib
, gsettings-desktop-schemas, gtk3, hicolor-icon-theme
, mpv, python3, python3Packages, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "hypnotix";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "hypnotix";
    rev = version;
    sha256 = "1silrdyi1i6dghcxs91vhqw76srmxjqbrqcyzsjmddsv8a0nzaim";
  };

  buildInputs = [
    dconf
    gettext
    glib
    gsettings-desktop-schemas
    gtk3
    hicolor-icon-theme
    mpv
    python3
    python3Packages.wrapPython
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    imdbpy
    mpv
    pycairo
    pygobject3
    requests
    setproctitle
    unidecode
    xapp
  ];

  dontConfigure = true;

  pythonPath = propagatedBuildInputs;

  libPath = lib.makeLibraryPath buildInputs;

  postPatch = ''
    substituteInPlace usr/bin/hypnotix --replace "/usr/lib/hypnotix" "$out/lib/hypnotix"
    substituteInPlace usr/lib/hypnotix/hypnotix.py --replace "/usr/share/hypnotix" "$out/share/hypnotix"
  '';

  installPhase = ''
    runHook preInstall

    install -D     -t "$out"/bin usr/bin/hypnotix
    install -D     -t "$out"/lib/hypnotix usr/lib/hypnotix/{common,hypnotix}.py
    install -Dm644 -t "$out"/lib/hypnotix usr/lib/hypnotix/mpv.py
    install -Dm644 -t "$out"/share/applications usr/share/applications/hypnotix.desktop
    install -Dm644 -t "$out"/share/glib-2.0/schemas usr/share/glib-2.0/schemas/org.x.hypnotix.gschema.xml
    install -Dm644 -t "$out"/share/hypnotix usr/share/hypnotix/*.{css,png,ui}
    install -Dm644 -t "$out"/share/hypnotix/pictures usr/share/hypnotix/pictures/*.svg
    install -Dm644 -t "$out"/share/hypnotix/pictures/badges usr/share/hypnotix/pictures/badges/*
    install -Dm644 -t "$out"/share/icons/hicolor/scalable/apps usr/share/icons/hicolor/scalable/apps/hypnotix.svg

    runHook postInstall
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas "$out"/share/glib-2.0/schemas
  '';

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/:$out/share"
      --prefix LD_LIBRARY_PATH : ${libPath}
    )
  '';

  meta = with lib; {
    description = "Hypnotix is an IPTV streaming application with support for live TV, movies and series.";
    homepage = "https://github.com/linuxmint/hypnotix";
    license = licenses.gpl3;
    maintainers = [ maintainers.loxley ];
    platforms = [ "x86_64-linux" ];
  };
}
