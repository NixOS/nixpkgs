{ stdenv, fetchFromGitHub, vala, pkgconfig, libxml2, cmake, ninja, gtk3, granite, gnome3
, gobjectIntrospection, sqlite, poppler, poppler_utils, html2text, unzip, unar, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "bookworm";
  version = "1.0.0";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "babluboy";
    repo = pname;
    rev = version;
    sha256 = "0nv1nxird0s0qfhh8fr82mkj4qimhklw1bwcjwmvjdsvsxxs9520";
  };

  nativeBuildInputs = [
    cmake
    gobjectIntrospection
    libxml2
    ninja
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = with gnome3; [
    glib
    granite
    gtk3
    html2text
    libgee
    poppler
    sqlite
    webkitgtk
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${stdenv.lib.makeBinPath [ unzip unar poppler_utils html2text ]}"
    )
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
