{ stdenv, fetchFromGitHub, intltool, autoreconfHook, pkgconfig, libqalculate, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "qalculate-gtk";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-gtk";
    rev = "v${version}";
    sha256 = "0yrzvsii84r9d2i2hrs4f65wzv3yj24l9d9yqfv3j85881h8wkm2";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ intltool pkgconfig autoreconfHook wrapGAppsHook ];
  buildInputs = [ libqalculate gtk3 ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [ gebner ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
