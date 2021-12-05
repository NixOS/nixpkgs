{ lib, stdenv, fetchFromGitHub, intltool, autoreconfHook, pkg-config
, libqalculate, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "qalculate-gtk";
  version = "3.21.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-gtk";
    rev = "v${version}";
    sha256 = "sha256-w0frk1Nd1/HTo94VAbD7QjVuT8laPbmgd8ENTb0+89c=";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ intltool pkg-config autoreconfHook wrapGAppsHook ];
  buildInputs = [ libqalculate gtk3 ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "The ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [ gebner doronbehar ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
