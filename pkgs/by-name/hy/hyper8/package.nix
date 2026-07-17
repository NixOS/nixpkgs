{
  lib,
  rustPlatform,
  fetchFromCodeberg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyper8";
  version = "1.0.1";

  src = fetchFromCodeberg {
    owner = "simonrepp";
    repo = "hyper8";
    tag = finalAttrs.version;
    hash = "sha256-pvtQPL/hPgoKDLYWC/IL04db7Q/FUlgiExthu4xBQEw=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-AQAWGmzixDFfL7wqJJXCvNSYojVtYHRP0zqdj0C8JRE=";

  meta = {
    homepage = "https://hyper8.org";
    description = "Static site generator for video publishing.";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    mainProgram = "hyper8";
  };
})
