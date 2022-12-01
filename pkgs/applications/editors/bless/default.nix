{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, mono
, meson
, ninja
, gtk-sharp-2_0
, gettext
, makeWrapper
, glib
, gtk2-x11
, libxslt
, docbook_xsl
, python3
, itstool
}:

stdenv.mkDerivation rec {
  pname = "bless";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "afrantzis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rS+vJX0y9v1TiPsRfABroHiTuENQKEOxNsyKwagRuHM=";
  };

  buildInputs = [
    gtk-sharp-2_0
    mono
    # runtime only deps
    glib
    gtk2-x11
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    makeWrapper
    libxslt
    docbook_xsl
    python3
    itstool
  ];

  mesonFlags = [
    "-Dtests=false" # requires NUnit
  ];

  postPatch = ''
    patchShebangs .
  '';

  preFixup = ''
    MPATH="${gtk-sharp-2_0}/lib/mono/gtk-sharp-2.0:${glib.out}/lib:${gtk2-x11}/lib:${gtk-sharp-2_0}/lib"
    wrapProgram $out/bin/bless --prefix MONO_PATH : "$MPATH" --prefix LD_LIBRARY_PATH : "$MPATH" --prefix PATH : ${lib.makeBinPath [ mono ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/afrantzis/bless";
    description = "Gtk# Hex Editor";
    maintainers = [ maintainers.mkg20001 ];
    license = licenses.gpl2;
    platforms = platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
  };
}
