{
  lib,
  stdenv,
  autoreconfHook,
  intltool,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol-db";
  version = "20250106";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = pname;
    rev = version;
    sha256 = "sha256-ScKMqInwVUpR4hX1wMSBZu1wwEkddT4kosuewrbVsdM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
  ];

  meta = {
    description = "Monitor database for DDCcontrol";
    homepage = "https://github.com/ddccontrol/ddccontrol-db";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.pakhfn ];
  };
}
