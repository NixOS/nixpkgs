{ lib, stdenv, fetchFromGitHub, intltool, autoreconfHook, pkg-config, libqalculate, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "qalculate-gtk";
  version = "3.19.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-gtk";
    rev = "v${version}";
    sha256 = "1nrx7gp6f1yalbdda1gb97azhbr4xclq2xf08vvbvsk8jfd6fd2v";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ intltool pkg-config autoreconfHook wrapGAppsHook ];
  buildInputs = [ libqalculate gtk3 ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "The ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [ gebner ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
