{ stdenv, fetchFromGitHub, fetchpatch, pantheon, python3, python2, pkgconfig,
libxml2, cmake, ninja, gtk3, gnome3, glib, webkitgtk , gobject-introspection,
sqlite, poppler, poppler_utils, html2text, curl, gnugrep, coreutils, bash,
unzip, unar, wrapGAppsHook, pcre, libpthreadstubs, libXdmcp, utillinux,
libselinux, libsepol, libxkbcommon, epoxy, at-spi2-core, dbus }:

stdenv.mkDerivation rec {
  pname = "bookworm";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "babluboy";
    repo = pname;
    rev = version;
    sha256 = "0qzwvlwv3nbgzqxxd7kd4rlvld7k03ivmyh099rzm6z00mm4y031";
  };

  nativeBuildInputs = [
    bash
    gobject-introspection
    libxml2
    cmake
    ninja
    pkgconfig
    python3
    pantheon.vala
    wrapGAppsHook
  ];

  buildInputs = [
    at-spi2-core
    dbus
    epoxy
    glib
    gnome3.libgee
    gtk3
    html2text
    libpthreadstubs
    libselinux
    libsepol
    libXdmcp
    libxkbcommon
    pantheon.elementary-icon-theme
    pantheon.granite
    pcre
    poppler
    python2
    sqlite
    utillinux
    webkitgtk
  ];

  # These programs are expected in PATH from the source code and scripts
  preFixup = ''
    gappsWrapperArgs+=(
      --argv0 "$out/bin/com.github.babluboy.bookworm"
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
