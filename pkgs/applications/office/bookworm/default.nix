{ stdenv, fetchFromGitHub, fetchpatch, vala_0_40, python3, python2, pkgconfig, libxml2, meson, ninja, gtk3, granite, gnome3
, gobjectIntrospection, sqlite, poppler, poppler_utils, html2text, curl, gnugrep, coreutils, bash, unzip, unar, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "bookworm";
  version = "4f7b118281667d22f1b3205edf0b775341fa49cb";

  name = "${pname}-2018-10-21";

  src = fetchFromGitHub {
    owner = "babluboy";
    repo = pname;
    rev = version;
    sha256 = "0bcyim87zk4b4xmgfs158lnds3y8jg7ppzw54kjpc9rh66fpn3b9";
  };

  # See: https://github.com/babluboy/bookworm/pull/220
  patches = [
    (fetchpatch {
      url = "https://github.com/worldofpeace/bookworm/commit/b2faf685c46b95d6a2d4ec3725e4e4122b61e99a.patch";
      sha256 = "14az86cj5j65hngfflrp1rmnrkdrhg2a8pl7www3jgfwasxay975";
    })
  ];

  nativeBuildInputs = [
    bash
    gobjectIntrospection
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
