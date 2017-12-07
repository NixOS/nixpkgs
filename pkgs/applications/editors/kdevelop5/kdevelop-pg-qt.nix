{ stdenv, fetchurl, cmake, pkgconfig, extra-cmake-modules, qtbase }:

let
  pname = "kdevelop-pg-qt";
  version = "2.1.0";

in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  
  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "20d84d25bd40610bd6c0964e4fe0642e56c41b76a65575122dc5196649621e5d";
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
    license = with stdenv.lib.licenses; [ lgpl2Plus ];
  };
}
