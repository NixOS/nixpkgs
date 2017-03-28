{ stdenv, fetchurl, pkgconfig, libmtp, libid3tag, flac, libvorbis, gtk3
, gsettings_desktop_schemas, makeWrapper, gnome3
}:

let version = "1.3.10"; in

stdenv.mkDerivation {
  name = "gmtp-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/gmtp/gMTP-${version}/gmtp-${version}.tar.gz";
    sha256 = "b21b9a8e66ae7bb09fc70ac7e317a0e32aff3917371a7241dea73c41db1dd13b";
  };

  preFixup = ''
    wrapProgram $out/bin/gmtp \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share" \
      --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules"
  '';

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ libmtp libid3tag flac libvorbis gtk3 gsettings_desktop_schemas gnome3.dconf ];

  enableParallelBuilding = true;

  meta = {
    description = "A simple MP3 and Media player client for UNIX and UNIX like systems.";
    homepage = "https://gmtp.sourceforge.io";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.pbogdan ];
    license = stdenv.lib.licenses.bsd3;
  };
}
