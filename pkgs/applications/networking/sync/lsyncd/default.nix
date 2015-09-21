{ stdenv, fetchFromGitHub, automake, autoconf, lua, pkgconfig, rsync,
  asciidoc, libxml2, docbook_xml_dtd_45, docbook_xml_xslt, libxslt }:

stdenv.mkDerivation rec {
  name = "lsyncd-${version}";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "axkibe";
    repo = "lsyncd";
    rev = "release-${version}";
    sha256 = "0jvr2rv34jyjrv7188vdv1z8vgvm4wydqwsp9x5ksfzh9drbq5gn";
  };

  patches = [ ./configure-a2x-fix.patch ];

  preConfigurePhase = ''
    substituteInPlace default-rsync.lua \
      --replace "binary        = '/usr/bin/rsync'," "binary        = '${rsync}/bin/rsync',"
  '';

  configurePhase = ''
    ./autogen.sh --prefix=$out
    ./configure --prefix=$out
  '';

  buildInputs = [
    rsync
    automake autoconf lua pkgconfig
    asciidoc libxml2 docbook_xml_dtd_45 docbook_xml_xslt libxslt
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/axkibe/lsyncd;
    description = "A utility that synchronizes local directories with remote targets";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bobvanderlinden ];
  };
}
