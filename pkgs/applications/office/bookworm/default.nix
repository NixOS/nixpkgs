{ lib, stdenv, fetchFromGitHub, pantheon, vala, python3, python2, pkg-config, libxml2, meson, ninja, gtk3, glib, webkitgtk, libgee
, gobject-introspection, sqlite, poppler, poppler_utils, html2text, curl, gnugrep, coreutils, bash, unzip, unar, wrapGAppsHook
, appstream, desktop-file-utils }:

stdenv.mkDerivation rec {
  pname = "bookworm";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "babluboy";
    repo = pname;
    rev = version;
    sha256 = "0w0rlyahpgx0l6inkbj106agbnr2czil0vdcy1zzv70apnjz488j";
  };

  nativeBuildInputs = [
    bash
    gobject-introspection
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    pantheon.elementary-icon-theme
    pantheon.granite
    glib
    libgee
    gtk3
    html2text
    poppler
    python2
    sqlite
    webkitgtk
    appstream
    desktop-file-utils
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  # These programs are expected in PATH from the source code and scripts
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ unzip unar poppler_utils html2text coreutils curl gnugrep ]}"
      --prefix PATH : $out/bin
    )
  '';

  postFixup = ''
    patchShebangs $out/share/bookworm/scripts/mobi_lib/*.py
    patchShebangs $out/share/bookworm/scripts/tasks/*.sh
  '';

   meta = with lib; {
     description = "A simple, focused eBook reader";
     longDescription = ''
       Read the books you love without having to worry about different format complexities like epub, pdf, mobi, cbr, etc.
     '';
     homepage = "https://babluboy.github.io/bookworm/";
     license = licenses.gpl3Plus;
     platforms = platforms.linux;
   };
 }
