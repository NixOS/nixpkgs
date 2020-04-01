{ stdenv, fetchurl, cmake, pkgconfig, extra-cmake-modules, qtbase }:

let
  pname = "kdevelop-pg-qt";
  version = "2.2.1";

in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  
  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "0ay6m6j6zgrbcm48f14bass83bk4w5qnx76xihc05p69i9w32ff1";
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
