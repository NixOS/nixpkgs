{ lib, stdenv, fetchurl, cmake, pkg-config, extra-cmake-modules, qtbase }:

stdenv.mkDerivation rec {
  pname = "kdevelop-pg-qt";
  version = "2.2.2";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${pname}-${version}.tar.xz";
    sha256 = "sha256-PVZgTEefjwSuMqUj7pHzB4xxcRfQ3rOelz4iSUy7ZfE=";
  };

  nativeBuildInputs = [ cmake pkg-config extra-cmake-modules ];

  buildInputs = [ qtbase ];

  dontWrapQtApps = true;

  meta = with lib; {
    maintainers = [ maintainers.ambrop72 ];
    platforms = platforms.linux;
    description = "Parser-generator from KDevplatform";
    mainProgram = "kdev-pg-qt";
    longDescription = ''
      KDevelop-PG-Qt is the parser-generator from KDevplatform.
      It is used for some KDevelop-languagesupport-plugins (Ruby, PHP, CSS...).
    '';
    homepage = "https://www.kdevelop.org";
    license = with lib.licenses; [ lgpl2Plus ];
  };
}
