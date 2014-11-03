{stdenv, fetchgit, qt4, cmake, libxml2, libxslt}:

let

  srcComponents = fetchgit {
    url = git://caneda.git.sourceforge.net/gitroot/caneda/components;
    rev = "34cd36b620e0dfc57ba2d2b6168734ea9a2cfa9a";
    sha256 = "840f07921eecbf10e38e44e5c61c716295a16c98fbb75016d9a44e7dfee40e59";
  };

in

stdenv.mkDerivation rec {
  name = "caneda-git-2012-02-16";

  src = fetchgit {
    url = git://caneda.git.sourceforge.net/gitroot/caneda/caneda;
    rev = "fff9e2f7988fe5d062548cafeda1e5cd660769d1";
    sha256 = "dfbcac97f5a1b41ad9a63392394f37fb294cbf78c576673c9bc4a5370957b2c8";
  };

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  buildInputs = [ cmake qt4 libxml2 libxslt ];

  postInstall = ''
    mkdir $out/share/caneda/components
    cp -R ${srcComponents}/* $out/share/caneda/components
    chmod u+w -R $out/share/caneda/components
  '';

  meta = {
    description = "Open source EDA software focused on easy of use and portability";
    homepage = http://caneda.tuxfamily.org;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
