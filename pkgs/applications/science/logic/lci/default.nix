{stdenv, fetchurl, readline}: 
stdenv.mkDerivation rec {
  version = "0.6";
  pname = "lci";
  src = fetchurl {
    url = "mirror://sourceforge/lci/${pname}-${version}.tar.gz";
    sha256="204f1ca5e2f56247d71ab320246811c220ed511bf08c9cb7f305cf180a93948e";
  };
  buildInputs = [readline];
  meta = {
    description = ''Lambda calculus interpreter'';
    maintainers = with stdenv.lib.maintainers; [raskin];
    platforms = with stdenv.lib.platforms; linux;
    license = stdenv.lib.licenses.gpl3;
  };
}
