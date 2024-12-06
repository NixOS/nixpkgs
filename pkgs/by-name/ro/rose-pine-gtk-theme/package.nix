{ stdenvNoCC
, lib
, fetchFromGitHub
, gnome-themes-extra
, gtk-engine-murrine
, gtk_engines
}:

stdenvNoCC.mkDerivation rec {
  pname = "rose-pine-gtk-theme";
  version = "unstable-2022-09-01";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "gtk";
    rev = "7a4c40989fd42fd8d4a797f460c79fc4a085c304";
    sha256 = "0q74wjyrsjyym770i3sqs071bvanwmm727xzv50wk6kzvpyqgi67";
  };

  buildInputs = [
    gnome-themes-extra # adwaita engine for Gtk2
    gtk_engines # pixmap engine for Gtk2
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine # murrine engine for Gtk2
  ];

  # avoid the makefile which is only for theme maintainers
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/rose-pine{,-dawn,-moon}/gtk-4.0

    variants=("rose-pine" "rose-pine-dawn" "rose-pine-moon")
    for n in "''${variants[@]}"; do
      cp -r $src/gtk3/"''${n}"-gtk/* $out/share/themes/"''${n}"
      cp -r $src/gtk4/"''${n}".css $out/share/themes/"''${n}"/gtk-4.0/gtk.css
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Rosé Pine theme for GTK";
    homepage = "https://github.com/rose-pine/gtk";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [romildo the-argus];
  };
}
