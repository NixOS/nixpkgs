{
  lib,
  stdenv,
  fetchurl,
}:
let
  db = fetchurl {
    url = "mirror://savannah/hddtemp/hddtemp.db";
    sha256 = "1fr6qgns6qv7cr40lic5yqwkkc7yjmmgx8j0z6d93csg3smzhhya";
  };

in
stdenv.mkDerivation rec {
  pname = "hddtemp";
  version = "0.3-beta15";

  src = fetchurl {
    url = "mirror://savannah/hddtemp/hddtemp-${version}.tar.bz2";
    sha256 = "sha256-YYVBWEBUCT1TvootnoHJcXTzDwCvkcuHAKl+RC1571s=";
  };

  # from Gentoo
  patches = [
    ./byteswap.patch
    ./dontwake.patch
    ./execinfo.patch
    ./satacmds.patch
  ];

  configureFlags = [
    "--with-db-path=${placeholder "out"}/share/hddtemp/hddtemp.db"
  ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  postInstall = ''
    install -Dm444 ${db} $out/share/hddtemp/hddtemp.db
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tool for displaying hard disk temperature";
    homepage = "https://savannah.nongnu.org/projects/hddtemp/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
    mainProgram = "hddtemp";
  };
}
