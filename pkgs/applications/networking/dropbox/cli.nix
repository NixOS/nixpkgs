{ stdenv
, substituteAll
, pkgconfig
, fetchurl
, python3
, dropbox
, gtk3
, gnome3
, gdk_pixbuf
, gobject-introspection
}:

let
  version = "2019.02.14";
  dropboxd = "${dropbox}/bin/dropbox";
in
stdenv.mkDerivation {
  name = "dropbox-cli-${version}";

  outputs = [ "out" "nautilusExtension" ];

  src = fetchurl {
    url = "https://linux.dropboxstatic.com/packages/nautilus-dropbox-${version}.tar.bz2";
    sha256 = "09yg7q45sycl88l3wq0byz4a9k6sxx3m0r3szinvisfay9wlj35f";
  };

  strictDeps = true;

  patches = [
    (substituteAll {
      src = ./fix-cli-paths.patch;
      inherit dropboxd;
    })
  ];

  nativeBuildInputs = [
    pkgconfig
    gobject-introspection
    gdk_pixbuf
    # only for build, the install command also wants to use GTK through introspection
    # but we are using Nix for installation so we will not need that.
    (python3.withPackages (ps: with ps; [
      docutils
      pygobject3
    ]))
  ];

  buildInputs = [
    python3
    gtk3
    gnome3.nautilus
  ];

  configureFlags = [
    "--with-nautilus-extension-dir=${placeholder ''nautilusExtension''}/lib/nautilus/extensions-3.0"
  ];

  makeFlags = [
    "EMBLEM_DIR=${placeholder ''nautilusExtension''}/share/nautilus-dropbox/emblems"
  ];

  meta = {
    homepage = https://www.dropbox.com;
    description = "Command line client for the dropbox daemon";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    # NOTE: Dropbox itself only works on linux, so this is ok.
    platforms = stdenv.lib.platforms.linux;
  };
}
