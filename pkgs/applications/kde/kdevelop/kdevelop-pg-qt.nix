{ lib, stdenv, fetchurl, cmake, pkg-config, extra-cmake-modules, qtbase }:

stdenv.mkDerivation rec {
  pname = "kdevelop-pg-qt";
  version = "2.2.1";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${pname}-${version}.tar.xz";
    sha256 = "0ay6m6j6zgrbcm48f14bass83bk4w5qnx76xihc05p69i9w32ff1";
  };

  nativeBuildInputs = [ cmake pkg-config extra-cmake-modules ];

  buildInputs = [ qtbase ];

  dontWrapQtApps = true;

  meta = with lib; {
    maintainers = [ maintainers.ambrop72 ];
    platforms = platforms.linux;
    description = "Parser-generator from KDevplatform";
    longDescription = ''
      KDevelop-PG-Qt is the parser-generator from KDevplatform.
      It is used for some KDevelop-languagesupport-plugins (Ruby, PHP, CSS...).
    '';
    homepage = "https://www.kdevelop.org";
    license = with lib.licenses; [ lgpl2Plus ];
  };
}
