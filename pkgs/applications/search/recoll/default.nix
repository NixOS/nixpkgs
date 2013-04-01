{ stdenv, fetchurl, qt4, zlib, xapian, groff, libxslt, unzip, xpdf, antiword, catdoc, lyx, ghostscript, wv2, file, python}:

stdenv.mkDerivation rec {
  ver = "1.18.1";
  name = "recoll-${ver}";

  src = fetchurl {
    url = "http://www.lesbonscomptes.com/recoll/${name}.tar.gz";
    sha256 = "0cyrkx5aza3485avb2kxc6cbsqqrb32l1kq8ravr9d828331v84f";
  };

  buildInputs = [ qt4 zlib xapian groff libxslt unzip xpdf antiword catdoc lyx ghostscript wv2 file python ];

  meta = {
    description = "finds keywords inside documents as well as file names";
    longDescription = ''
      Xapian frontend that can search through files, archive members, email attachments. 
      '';
    homepage = http://www.lesbonscomptes.com/recoll/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
