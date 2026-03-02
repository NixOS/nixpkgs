{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libjpeg,
  libtiff,
  proj,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.7.4";
  pname = "libgeotiff";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "libgeotiff";
    rev = finalAttrs.version;
    hash = "sha256-oiuooLejCRI1DFTjhgYoePtKS+OAGnW6OBzgITcY500=";
  };

  outputs = [
    "out"
    "dev"
  ];

  sourceRoot = "${finalAttrs.src.name}/libgeotiff";

  configureFlags = [
    "--with-jpeg=${libjpeg.dev}"
    "--with-zlib=${zlib.dev}"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libtiff
    proj
    zlib
  ];

  #hardeningDisable = [ "format" ];

  meta = {
    description = "Library implementing attempt to create a tiff based interchange format for georeferenced raster imagery";
    homepage = "https://github.com/OSGeo/libgeotiff";
    changelog = "https://github.com/OSGeo/libgeotiff/blob/${finalAttrs.src.rev}/libgeotiff/NEWS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcweber ];
    teams = [ lib.teams.geospatial ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
