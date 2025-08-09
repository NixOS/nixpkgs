{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "KDSingleApplication";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = "KDSingleApplication";
    tag = "v${version}";
    hash = "sha256-rglt89Gw6OHXXVOEwf0TxezDzyHEvWepeGeup7fBlLs=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt6.qtbase ];

  cmakeFlags = [ "-DKDSingleApplication_QT6=true" ];
  dontWrapQtApps = true;

  meta = {
    description = "KDAB's helper class for single-instance policy applications";
    homepage = "https://www.kdab.com/";
    maintainers = with lib.maintainers; [ hellwolf ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    changelog = "https://github.com/KDAB/KDSingleApplication/releases/tag/v${version}";
  };
}
