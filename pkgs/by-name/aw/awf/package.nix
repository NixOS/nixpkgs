{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gtk2,
  gtk3,
  gtk4,
  libnotify,
  hicolor-icon-theme,
  pkg-config,
  wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "awf";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "luigifab";
    repo = "awf-extended";
    tag = "v${version}";
    sha256 = "60e71e05a6620b54debc0a148ddbf911fc314b1e0cf6c9cf159a104bfca57bb6";
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
  ];

  configureFlags = [ "--disable-gtk5" ];

  autoreconfPhase = ''
    autoreconf -fi
  '';

  installPhase = ''
    runHook preInstall

    for gtk in "gtk2" "gtk3" "gtk4"; do

        install -Dpm 644 data/awf-$$gtk.desktop $out/share/applications/awf-$$gtk.desktop

        cp -ar data/icons/ icons-$$gtk/
        for file in icons-$$gtk/*/*/awf.png; do mv $$file `dirname $$file`/awf-$$gtk.png; done
        for file in icons-$$gtk/*/*/awf.svg; do mv $$file `dirname $$file`/awf-$$gtk.svg; done
        install -dm 755 $out/share/icons/hicolor/
        cp -a icons-$$gtk/* $out/share/icons/hicolor/

        install -Dpm 644 data/awf-$$gtk.bash $out/share/bash-completion/completions/awf-$$gtk
        install -Dpm 644 data/awf-$$gtk.1 $out/share/man/man1/awf-$$gtk.1
        install -Dpm 644 data/awf-$$gtk.fr.1 $out/share/man/fr/man1/awf-$$gtk.1

        for file in src/po/*.po; do
            code=`basename "$$file" .po`
            mkdir -p locale-$$gtk/$$code/LC_MESSAGES/
            msgfmt src/po/$$code.po -o locale-$$gtk/$$code/LC_MESSAGES/awf-$$gtk.mo
            install -Dpm 644 locale-$$gtk/$$code/LC_MESSAGES/awf-$$gtk.mo $out/share/locale/$$code/LC_MESSAGES/awf-$$gtk.mo
        done
    done

    rm -rf icons-gtk*/ locale-gtk*/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Theme preview application for GTK";
    longDescription = ''
      A widget factory is a theme preview application for GTK. It displays the
      various widget types provided by GTK in a single window allowing to see
      the visual effect of the applied theme.
    '';
    homepage = "https://github.com/luigifab/awf-extended";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ luigifab ];
  };
}
