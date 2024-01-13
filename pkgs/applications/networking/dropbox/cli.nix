{ lib, stdenv
, substituteAll
, autoreconfHook
, pkg-config
, fetchurl
, python3
, dropbox
, gtk4
, gnome
, gdk-pixbuf
, gobject-introspection
}:

let
  version = "2023.09.06";
  dropboxd = "${dropbox}/bin/dropbox";
in
stdenv.mkDerivation {
  pname = "dropbox-cli";
  inherit version;

  outputs = [ "out" "nautilusExtension" ];

  src = fetchurl {
    url = "https://linux.dropbox.com/packages/nautilus-dropbox-${version}.tar.bz2";
    hash = "sha256-kZMwj8Fn8Hf58C57wE025TlmiSs5TaKMGEzvb2QjgSw=";
  };

  strictDeps = true;

  patches = [
    (substituteAll {
      src = ./fix-cli-paths.patch;
      inherit dropboxd;
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gobject-introspection
    gdk-pixbuf
    # only for build, the install command also wants to use GTK through introspection
    # but we are using Nix for installation so we will not need that.
    (python3.withPackages (ps: with ps; [
      docutils
      pygobject3
    ]))
  ];

  buildInputs = [
    python3
    gtk4
    gnome.nautilus
  ];

  configureFlags = [
    "--with-nautilus-extension-dir=${placeholder "nautilusExtension"}/lib/nautilus/extension-4"
  ];

  makeFlags = [
    "EMBLEM_DIR=${placeholder "nautilusExtension"}/share/nautilus-dropbox/emblems"
  ];

  meta = {
    homepage = "https://www.dropbox.com";
    description = "Command line client for the dropbox daemon";
    license = lib.licenses.gpl3Plus;
    mainProgram = "dropbox";
    maintainers = with lib.maintainers; [ eclairevoyant ];
    # NOTE: Dropbox itself only works on linux, so this is ok.
    platforms = lib.platforms.linux;
  };
}
