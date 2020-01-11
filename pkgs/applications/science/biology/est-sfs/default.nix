{ stdenv, fetchurl, gsl }:

stdenv.mkDerivation rec {
  pname = "est-sfs";
  version = "2.03";

  src = fetchurl {
    url = "mirror://sourceforge/est-usfs/${pname}-release-${version}.tar.gz";
    sha256 = "1hvamrgagz0xi89w8qafyd9mjrdpyika8zm22drddnjkp4sdj65n";
  };

  buildInputs = [ gsl ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/doc/${pname}
    cp est-sfs $out/bin
    cp est-sfs-documentation.pdf $out/share/doc/${pname}
  '';

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/est-usfs;
    description = "Estimate the unfolded site frequency spectrum and ancestral states";
    license = licenses.gpl3;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.all;
  };
}
