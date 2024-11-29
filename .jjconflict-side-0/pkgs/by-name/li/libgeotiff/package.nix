{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libjpeg
, libtiff
, proj
, zlib
}:

stdenv.mkDerivation rec {
  version = "1.7.3";
  pname = "libgeotiff";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "libgeotiff";
    rev = version;
    hash = "sha256-FUvWZR5BrGEMnApxCBQBwmmi9NU7Tx6Ziq3mbIxjqfc=";
  };

  outputs = [ "out" "dev" ];

  sourceRoot = "${src.name}/libgeotiff";

  configureFlags = [
    "--with-jpeg=${libjpeg.dev}"
    "--with-zlib=${zlib.dev}"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libtiff proj ];

  #hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Library implementing attempt to create a tiff based interchange format for georeferenced raster imagery";
    homepage = "https://github.com/OSGeo/libgeotiff";
    changelog = "https://github.com/OSGeo/libgeotiff/blob/${src.rev}/libgeotiff/NEWS";
    license = licenses.mit;
    maintainers = with maintainers; teams.geospatial.members ++ [ marcweber ];
    platforms = with platforms; linux ++ darwin;
  };
}
