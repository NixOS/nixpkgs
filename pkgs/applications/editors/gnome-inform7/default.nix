{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  perl,
  bison,
  texinfo,
  desktop-file-utils,
  wrapGAppsHook3,
  docbook2x,
  docbook-xsl-nons,
  inform7,
  gettext,
  libossp_uuid,
  gtk3,
  gobject-introspection,
  vala,
  gtk-doc,
  webkitgtk,
  gtksourceview3,
  gspell,
  libxml2,
  goocanvas2,
  libplist,
  glib,
  gst_all_1,
}:

# Neither gnome-inform7 nor its dependencies ratify and chimara have tagged releases in the GTK3 branch yet.

let
  ratify = (
    stdenv.mkDerivation {
      pname = "ratify";
      version = "unstable-2021-02-21";
      src = fetchFromGitHub {
        owner = "ptomato";
        repo = "ratify";
        rev = "f4d2d60ec73d5588e953650b3879e69a727f30ca";
        sha256 = "eRh/9pYvdfbdbdJQ7pYMLq5p91I+rtyb/AqEGfakjKs=";
      };
      nativeBuildInputs = [
        meson
        ninja
        pkg-config
        docbook2x
        docbook-xsl-nons
        wrapGAppsHook3
        gobject-introspection
      ];
      buildInputs = [
        gtk3
        vala
        gtk-doc
      ];
    }
  );

  chimara = (
    stdenv.mkDerivation {
      pname = "chimara";
      version = "unstable-2021-04-06";
      src = fetchFromGitHub {
        owner = "chimara";
        repo = "Chimara";
        rev = "9934b142af508c75c0f1eed597990f39495b1af4";
        sha256 = "aRz1XX8XaSLTBIrMIIMS3QNMm6Msi+slrZ6+KYlyRMo=";
      };
      nativeBuildInputs = [
        meson
        ninja
        pkg-config
        perl
        bison
        texinfo
        python3
        glib
        wrapGAppsHook3
        gobject-introspection
      ];
      buildInputs = [
        gtk3
        vala
        gtk-doc
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        glib
      ];
      preConfigure = ''
        patchShebangs build-aux/meson_post_install.py
      '';
    }
  );

in
stdenv.mkDerivation {
  pname = "gnome-inform7";
  version = "unstable-2021-04-06";
  src = fetchFromGitHub {
    owner = "ptomato";
    repo = "gnome-inform7";
    # build from revision in the GTK3 branch as mainline requires webkit-1.0
    rev = "c37e045c159692aae2e4e79b917e5f96cfefa66a";
    sha256 = "Q4xoITs3AYXhvpWaABRAvJaUWTtUl8lYQ1k9zX7FrNw=";
  };
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    inform7
    python3
    desktop-file-utils
    wrapGAppsHook3
  ];
  buildInputs = [
    gettext
    libossp_uuid
    gtk3
    gtksourceview3
    gspell
    webkitgtk
    libxml2
    goocanvas2
    libplist
    ratify
    chimara
  ];
  preConfigure = ''
    cp ${inform7}/libexec/ni ./src/ni
    patchShebangs build-aux/* src/generate-resource-xml.{py,sh}
  '';

  meta = with lib; {
    description = "Inform 7 for the Gnome platform";
    longDescription = ''
      This version of Inform 7 for the Gnome platform was created by Philip Chimento, based on a design by Graham Nelson and Andrew Hunter.
    '';
    homepage = "https://github.com/ptomato/gnome-inform7";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.fitzgibbon ];
    platforms = platforms.linux;
    mainProgram = "gnome-inform7";
  };
}
