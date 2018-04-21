{ stdenv, fetchurl, pkgconfig, intltool, perl, perlXMLParser
, goffice, gnome3, makeWrapper, gtk3, bison, pythonPackages
, itstool
}:

let
  inherit (pythonPackages) python pygobject3;
  isopub = fetchurl { url = http://www.oasis-open.org/docbook/xml/4.5/ent/isopub.ent; sha256 = "073l492jz70chcadr2p7ssx7gz5hd731s2cazhxx4r845kilyr77"; };
  isonum = fetchurl { url = http://www.oasis-open.org/docbook/xml/4.5/ent/isonum.ent; sha256 = "04b62dw2g3cj9i4vn9xyrsrlz8fpmmijq98dm0nrkky31bwbbrs3"; };
  isogrk1 = fetchurl { url = http://www.oasis-open.org/docbook/xml/4.5/ent/isogrk1.ent; sha256 = "04b23anhs5wr62n4rgsjirzvw7rpjcsf8smz4ffzaqh3b0vw90vm"; };
in stdenv.mkDerivation rec {
  name = "gnumeric-1.12.39";

  src = fetchurl {
    url = "mirror://gnome/sources/gnumeric/1.12/${name}.tar.xz";
    sha256 = "26cceb7fa97dc7eee7181a79a6251a85b1f1464dcaaaf7624829f7439c5f7d3f";
  };

  configureFlags = "--disable-component";

  prePatch = ''
    substituteInPlace doc/C/gnumeric.xml \
	--replace http://www.oasis-open.org/docbook/xml/4.5/ent/isopub.ent ${isopub} \
	--replace http://www.oasis-open.org/docbook/xml/4.5/ent/isonum.ent ${isonum} \
	--replace http://www.oasis-open.org/docbook/xml/4.5/ent/isogrk1.ent ${isogrk1}
  '';

  nativeBuildInputs = [ pkgconfig ];

  # ToDo: optional libgda, introspection?
  buildInputs = [
    intltool perl perlXMLParser bison
    goffice gtk3 makeWrapper gnome3.defaultIconTheme
    python pygobject3 itstool
  ];

  enableParallelBuilding = true;

  preFixup = ''
    for f in "$out"/bin/gnumeric-*; do
      wrapProgram $f \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
        ${stdenv.lib.optionalString (!stdenv.isDarwin) "--prefix GIO_EXTRA_MODULES : '${stdenv.lib.getLib gnome3.dconf}/lib/gio/modules'"}
    done
  '';

  meta = with stdenv.lib; {
    description = "The GNOME Office Spreadsheet";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://projects.gnome.org/gnumeric/;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
