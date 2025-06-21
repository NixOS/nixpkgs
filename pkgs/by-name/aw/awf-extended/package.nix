{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  autoreconfHook,
  gtk2,
  gtk3,
  gtk4,
  libnotify,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "awf-extended";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "luigifab";
    repo = "awf-extended";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HZEsg3eEysPSkj3hj6KwcZTUI5FOzbOEYbu6RDdx9q4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk2
    gtk3
    gtk4
    libnotify
  ];

  patches = [
    (replaceVars ./include-paths.patch {
      gtk2 = gtk2.dev;
      gtk3 = gtk3.dev;
      gtk4 = gtk4.dev;
      GTK2_SUFFIX = null;
      GTK3_SUFFIX = null;
      GTK4_SUFFIX = null;
      GTK5_SUFFIX = null;
    })
  ];

  configureFlags = [ "--disable-gtk5" ];

  autoreconfPhase = ''
    autoreconf -fi
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    for gtk in "gtk2" "gtk3" "gtk4"; do

        cp src/awf-$gtk $out/bin
        install -Dpm 644 data/awf-$gtk.desktop $out/share/applications/awf-$gtk.desktop

        cp -ar data/icons/ icons-$gtk/
        for file in icons-$gtk/*/*/awf.png; do mv $file `dirname $file`/awf-$gtk.png; done
        for file in icons-$gtk/*/*/awf.svg; do mv $file `dirname $file`/awf-$gtk.svg; done
        install -dm 755 $out/share/icons/hicolor/
        cp -a icons-$gtk/* $out/share/icons/hicolor/

        install -Dpm 644 data/awf-$gtk.bash $out/share/bash-completion/completions/awf-$gtk
        install -Dpm 644 data/awf-$gtk.1 $out/share/man/man1/awf-$gtk.1
        install -Dpm 644 data/awf-$gtk.fr.1 $out/share/man/fr/man1/awf-$gtk.1

        for file in src/po/*.po; do
            code=`basename "$file" .po`
            mkdir -p locale-$gtk/$code/LC_MESSAGES/
            msgfmt src/po/$code.po -o locale-$gtk/$code/LC_MESSAGES/awf-$gtk.mo
            install -Dpm 644 locale-$gtk/$code/LC_MESSAGES/awf-$gtk.mo $out/share/locale/$code/LC_MESSAGES/awf-$gtk.mo
        done
    done

    runHook postInstall
  '';

  meta = {
    description = "Theme preview application for GTK";
    longDescription = ''
      A widget factory is a theme preview application for GTK. It displays the
      various widget types provided by GTK in a single window allowing to see
      the visual effect of the applied theme.
    '';
    homepage = "https://github.com/luigifab/awf-extended";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ michalrus ];
  };
})
