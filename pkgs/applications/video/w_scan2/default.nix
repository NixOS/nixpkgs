{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "w_scan2";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "stefantalpalaru";
    repo = "w_scan2";
    rev = version;
    sha256 = "sha256-fDFAJ4EMwu4X1Go3jkRjwA66xDY4tJ5wCKlEdZUT4qQ=";
  };

  meta = {
    description = "A small channel scan tool which generates ATSC, DVB-C, DVB-S/S2 and DVB-T/T2 channels.conf files";
    homepage = "https://github.com/stefantalpalaru/w_scan2";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ _0x4A6F ] ;
    license = lib.licenses.gpl2Only;
  };
}
