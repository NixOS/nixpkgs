{ stdenv, fetchurl, cmake, pkgconfig, extra-cmake-modules, qtbase }:

let
  pname = "kdevelop-pg-qt";
  version = "1.90.92";

in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  
  src = fetchurl {
    url = "mirror://kde/unstable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "a522adc9f77727197dcfcf7e68c3602fa0c6447d4d41156a6d954a1e22f8c5b1";
  };

  nativeBuildInputs = [ cmake pkgconfig extra-cmake-modules ];
  
  buildInputs = [ qtbase ];

  meta = with stdenv.lib; {
    maintainers = [ maintainers.ambrop72 ];
    platforms = platforms.linux;
    description = "Parser-generator from KDevplatform";
    longDescription = ''
      KDevelop-PG-Qt is the parser-generator from KDevplatform.
      It is used for some KDevelop-languagesupport-plugins (Ruby, PHP, CSS...).
    '';
    homepage = https://www.kdevelop.org;
  };
}
