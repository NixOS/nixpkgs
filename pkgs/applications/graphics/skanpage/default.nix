{ lib
, mkDerivation
, fetchurl
, extra-cmake-modules
, kirigami2
, ktextwidgets
, libksane
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "skanpage";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://kde/stable/skanpage/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-kPVAG64oPkKF3ztHB4V7M2xc1AcvwiHnYpMMLMQNYGA=";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [
    kirigami2
    ktextwidgets
    libksane
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "KDE utility to scan images and multi-page documents";
    homepage = "https://apps.kde.org/skanpage";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ samuelgrf ];
    platforms = platforms.linux;
  };
}
