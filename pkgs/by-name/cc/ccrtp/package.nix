{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  ucommon,
  openssl,
  libgcrypt,
}:

stdenv.mkDerivation rec {
  pname = "ccrtp";
  version = "2.1.2";

  src = fetchurl {
    url = "mirror://gnu/ccrtp/ccrtp-${version}.tar.gz";
    sha256 = "17ili8l7zqbbkzr1rcy4hlnazkf50mds41wg6n7bfdsx3c7cldgh";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [
    ucommon
    openssl
    libgcrypt
  ];

  configureFlags = [
    "--disable-demos"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Implementation of the IETF real-time transport protocol (RTP)";
    homepage = "https://www.gnu.org/software/ccrtp/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.linux;
  };
}
