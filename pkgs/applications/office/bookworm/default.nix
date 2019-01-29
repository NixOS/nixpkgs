{ stdenv, fetchFromGitHub, fetchpatch, vala_0_40, python3, python2, pkgconfig, libxml2, meson, ninja, gtk3, granite, gnome3
, gobject-introspection, sqlite, poppler, poppler_utils, html2text, curl, gnugrep, coreutils, bash, unzip, unar, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "bookworm";
  version = "unstable-2018-11-19";

  src = fetchFromGitHub {
    owner = "babluboy";
    repo = pname;
    rev = "4c3061784ff42151cac77d12bf2a28bf831fdfc5";
    sha256 = "0yrqxa60xlvz249kx966z5krx8i7h17ac0hjgq9p8f0irzy5yp0n";
  };

  nativeBuildInputs = [
    bash
    gobject-introspection
    libxml2
    meson
    ninja
    pkgconfig
    python3
    vala_0_40 # should be `elementary.vala` when elementary attribute set is merged
    wrapGAppsHook
  ];

  buildInputs = with gnome3; [
    glib
    gnome3.defaultIconTheme # should be `elementary.defaultIconTheme`when elementary attribute set is merged
    granite
    gtk3
    html2text
    libgee
    poppler
    python2
    sqlite
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  # These programs are expected in PATH from the source code and scripts
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${stdenv.lib.makeBinPath [ unzip unar poppler_utils html2text coreutils curl gnugrep ]}"
      --prefix PATH : $out/bin
    )
  '';

  postFixup = ''
    patchShebangs $out/share/bookworm/scripts/mobi_lib/*.py
    patchShebangs $out/share/bookworm/scripts/tasks/*.sh
  '';

   meta = with stdenv.lib; {
     description = "A simple, focused eBook reader";
     longDescription = ''
       Read the books you love without having to worry about different format complexities like epub, pdf, mobi, cbr, etc.
     '';
     homepage = https://babluboy.github.io/bookworm/;
     license = licenses.gpl3Plus;
     platforms = platforms.linux;
   };
 }
