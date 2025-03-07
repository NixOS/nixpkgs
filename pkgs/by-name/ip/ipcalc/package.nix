{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  ronn,
  withGeo ? true,
  geoip,
}:

# In order for the geoip part to work, you need to set up a link from
# geoip.dataDir to a directory containing the data files This would typically be
# /var/lib/geoip-databases pointing to geoip-legacy/share/GeoIP

stdenv.mkDerivation rec {
  pname = "ipcalc";
  version = "1.0.3";

  src = fetchFromGitLab {
    owner = "ipcalc";
    repo = "ipcalc";
    rev = version;
    hash = "sha256-9eaR1zG8tjSGlkpyY1zTHAVgN5ypuyRfeRq6ct6zsLU=";
  };

  patches = [
    # disable tests which fail in NixOS sandbox (trying to access the network)
    ./sandbox_tests.patch
  ];

  # technically not needed as we do not support the paid maxmind databases, but
  # keep it around if someone wants to add support and /usr/share/GeoIP is
  # broken anyway
  postPatch = ''
    substituteInPlace ipcalc-maxmind.c \
      --replace /usr/share/GeoIP /var/lib/GeoIP
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    ronn
  ];

  buildInputs = [ geoip ];

  mesonFlags = [
    "-Duse_geoip=${if withGeo then "en" else "dis"}abled"
    "-Duse_maxminddb=disabled"
    # runtime linking doesn't work on NixOS anyway
    "-Duse_runtime_linking=disabled"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Simple IP network calculator";
    homepage = "https://gitlab.com/ipcalc/ipcalc";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
    mainProgram = "ipcalc";
  };
}
