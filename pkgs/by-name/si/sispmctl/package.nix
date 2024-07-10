{ lib
, stdenv
, fetchurl
, pkg-config
, libusb-compat-0_1
}:

stdenv.mkDerivation rec {
  pname = "sispmctl";
  version = "4.12";

  src = fetchurl {
    url = "mirror://sourceforge/sispmctl/sispmctl-${version}.tar.gz";
    hash = "sha256-51eGOkg42m4cpypXrcWspvxH/73ccqaQUtir10PVcII=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb-compat-0_1
  ];

  meta = with lib; {
    homepage = "https://sispmctl.sourceforge.net/";
    description = "USB controlled powerstrips management software";
    license = licenses.gpl2Plus;
    mainProgram = "sispmctl";
    maintainers = [ maintainers._9R ];
    platforms = platforms.unix;
  };
}
