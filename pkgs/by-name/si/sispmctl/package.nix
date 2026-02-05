{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libusb-compat-0_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sispmctl";
  version = "4.12";

  src = fetchurl {
    url = "mirror://sourceforge/sispmctl/sispmctl-${finalAttrs.version}.tar.gz";
    hash = "sha256-51eGOkg42m4cpypXrcWspvxH/73ccqaQUtir10PVcII=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb-compat-0_1
  ];

  meta = {
    homepage = "https://sispmctl.sourceforge.net/";
    description = "USB controlled powerstrips management software";
    license = lib.licenses.gpl2Plus;
    mainProgram = "sispmctl";
    maintainers = [ lib.maintainers._9R ];
    platforms = lib.platforms.unix;
  };
})
