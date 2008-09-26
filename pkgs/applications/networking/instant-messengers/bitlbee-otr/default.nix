{ stdenv, fetchbzr, gnutls, glib, pkgconfig, libotr, libgcrypt
, libxslt, xmlto, docbook_xsl, docbook_xml_dtd_42, perl }:

let revision = "369"; in
stdenv.mkDerivation rec {
  name = "bitlbee-otr-r${revision}";
  src = fetchbzr {
    url = "http://khjk.org/~pesco/bitlbee-otr";
    sha256 = "0fb7987ec4a321e07f22690ed6617db9f377fdf4e65a531d8da28a950817074f";
    inherit revision;
  };

  patchPhase = ''
    # Both OTR and GnuTLS depend on libgcrypt, but for some reason, `bitlbee'
    # must be explicitly linked against it.
    sed -i "configure" -e "s|-f \$""{i}/lib/libotr.a|0 -eq 0|g ;
                           s|otrprefix=\$""{i}|otrprefix=\"${libotr}\"|g ;
                           s|-lotr|-lotr -L${libgcrypt} -lgcrypt|g";
  '';

  buildInputs = [ gnutls glib pkgconfig libotr libgcrypt
    libxslt xmlto docbook_xsl docbook_xml_dtd_42 perl
  ];

  meta = {
    description = ''BitlBee, an IRC to other chat networks gateway.'';

    longDescription = ''
      This unofficial version adds support for communication encryption
      and authentication via the OTR (off-the-record) library.
    '';

    # See also http://bugs.bitlbee.org/bitlbee/ticket/115 .
    homepage = http://khjk.org/bitlbee-otr/;

    license = "GPL";
  };
}
