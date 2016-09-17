{ stdenv, fetchurl, cmake, pkgconfig, extra-cmake-modules, qtbase }:

let
  pname = "kdevelop-pg-qt";
  version = "2.0";
  dirVersion = "2.0.0";

in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  
  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${dirVersion}/src/${name}.tar.xz";
    sha256 = "2f778d324b7c0962e8bb5f62dd2643bac1a6f3ac971d145b6aace7cd61878993";
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
