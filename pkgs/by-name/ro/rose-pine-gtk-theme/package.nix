{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  gnome-themes-extra,
  gtk-engine-murrine,
  gtk_engines,
}:

stdenvNoCC.mkDerivation rec {
  pname = "rose-pine-gtk-theme";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "gtk";
    tag = "v${version}";
    hash = "sha256-vCWs+TOVURl18EdbJr5QAHfB+JX9lYJ3TPO6IklKeFE=";
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
    maintainers = with maintainers; [
      romildo
      the-argus
    ];
  };
}
