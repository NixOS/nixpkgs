{ lib, stdenv, fetchFromGitHub, intltool, autoreconfHook, pkg-config, libqalculate, gtk3, wrapGAppsHook, qalculate-gtk, testVersion }:

stdenv.mkDerivation rec {
  pname = "qalculate-gtk";
  version = "3.22.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-gtk";
    rev = "v${version}";
    sha256 = "sha256-BarbO25c103YImOOnjVgwgqpa3mUVvndgJeUHRf2I60=";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ intltool pkg-config autoreconfHook wrapGAppsHook ];
  buildInputs = [ libqalculate gtk3 ];
  enableParallelBuilding = true;

  passthru.tests.version = testVersion { package = qalculate-gtk; };

  meta = with lib; {
    description = "The ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [ gebner doronbehar ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
