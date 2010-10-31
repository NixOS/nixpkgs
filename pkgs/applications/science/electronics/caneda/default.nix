{stdenv, fetchgit, qt4, cmake, libxml2, libxslt}:

let
  srcComponents = fetchgit {
    url = git://git.tuxfamily.org/gitroot/caneda/components.git;
    rev = "9ff20b6ad1b8f639441123f195337121f3b02404";
    sha256 = "32f12e72eaadca7b8e409ee12c55fbbdbf43dfa9bc9675ac8458da6393ef3cad";
  };

in

stdenv.mkDerivation rec {
  name = "caneda-git-2010-10-24";

  src = fetchgit {
    url = git://git.tuxfamily.org/gitroot/caneda/caneda.git;
    rev = "62fc0d8e248705ea51269dce8f291ff69924728e";
    sha256 = "8fa928b7dbd235eff3d938c5a1212ee360c6a90aab7b396eea2f5fe68aba7ab0";
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
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
