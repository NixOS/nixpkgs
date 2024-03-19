{ stdenv
, lib
, fetchFromGitHub
, crystal
, wrapGAppsHook4
, gobject-introspection
, desktopToDarwinBundle
, webkitgtk_6_0
, sqlite
, gi-crystal
, libadwaita
, gtk4
, pango
}:
let
  gtk4' = gtk4.override { x11Support = true; };
  pango' = pango.override { withIntrospection = true; };
in
crystal.buildCrystalPackage rec {
  pname = "rtfm";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "hugopl";
    repo = "rtfm";
    rev = "v${version}";
    name = "rtfm";
    hash = "sha256-IfI7jYM1bsrCq2NiANv/SWkCjPyT/HYUofJMUYy0Sbk=";
  };

  patches = [
    # 1) fixed gi-crystal binding generator command
    # 2) removed `-v` arg to `cp` command to prevent build failure due to stdout buffer overflow
    # 3) added commands to build gschemas and update icon-cache
    ./patches/make.patch

    # fixed docset path and gi libs directory names
    ./patches/friendly-docs-path.patch

    # added chmod +w for copied docs to prevent error:
    # `Error opening file with mode 'wb': '.../style.css': Permission denied`
    ./patches/enable-write-permissions.patch
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "crystal run src/create_crystal_docset.cr" "crystal src/create_crystal_docset.cr ${crystal}/share/doc/crystal/api/" \
      --replace "crystal run src/create_gtk_docset.cr" "crystal src/create_gtk_docset.cr gtk-doc/"
  '';

  shardsFile = ./shards.nix;

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
    gi-crystal
  ] ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    webkitgtk_6_0
    sqlite
    libadwaita
    gtk4'
    pango'
  ];

  buildTargets = [ "configure" "rtfm" "docsets" ];

  preBuild = ''
    mkdir gtk-doc/

    for file in "${gtk4'.devdoc}"/share/doc/*; do
      ln -s "$file" "gtk-doc/$(basename "$file")"
    done

    for file in "${pango'.devdoc}"/share/doc/*; do
      ln -s "$file" "gtk-doc/$(basename "$file")"
    done

    for file in "${libadwaita.devdoc}"/share/doc/*; do
      ln -s "$file" "gtk-doc/$(basename "$file")"
    done
  '';

  meta = with lib; {
    description = "Dash/docset reader with built in documentation for Crystal and GTK APIs";
    homepage = "https://github.com/hugopl/rtfm/";
    license = licenses.mit;
    maintainers = with maintainers; [ sund3RRR ];
  };
}
