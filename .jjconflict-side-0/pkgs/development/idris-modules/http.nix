{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  lightyear,
  bytes,
  lib,
}:
build-idris-package {
  pname = "http";
  version = "2018-02-25";

  idrisDeps = [
    contrib
    lightyear
    bytes
  ];

  src = fetchFromGitHub {
    owner = "uwap";
    repo = "idris-http";
    rev = "dc4a31543f87c0bc44cbaa98192f0303cd8dd82e";
    hash = "sha256-iF5PStEznJz+Cj/8kpC1F27mp+blAXUeca76GUvkeak=";
  };

  meta = {
    description = "HTTP library for idris";
    homepage = "https://github.com/uwap/idris-http";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
