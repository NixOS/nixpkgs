{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, drvName ? "geoip"

  # in geoipDatabase, you can insert a package defining
  # "${geoipDatabase}/share/GeoIP" e.g. geolite-legacy
, geoipDatabase ? "/var/lib/geoip-databases"
}:

let
  dataDir =
    if lib.isDerivation geoipDatabase
    then "${toString geoipDatabase}/share/GeoIP"
    else geoipDatabase;

in
stdenv.mkDerivation rec {
  pname = drvName;
  version = "1.6.12";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoip-api-c";
    rev = "v${version}";
    sha256 = "0ixyp3h51alnncr17hqp1p0rlqz9w69nlhm60rbzjjz3vjx52ajv";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # Cross compilation shenanigans
  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  # Fix up the default data directory
  postConfigure = ''
    find . -name Makefile.in -exec sed -i -r 's#^pkgdatadir\s*=.+$#pkgdatadir = ${dataDir}#' {} \;
  '';

  passthru = { inherit dataDir; };

  meta = with lib; {
    description = "API for GeoIP/Geolocation databases";
    maintainers = with maintainers; [ thoughtpolice raskin ];
    license = licenses.lgpl21;
    platforms = platforms.unix;
    homepage = "https://www.maxmind.com";
  };
}
