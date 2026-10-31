{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmeshb";
  version = "8.02";

  src = fetchFromGitHub {
    owner = "LoicMarechal";
    repo = "libMeshb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LdnjdamWzm/iihnBwjbUBMwLXNhtM+LRsTUEX4GYkgk=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  meta = {
    description = "A library to handle the *.meshb file format.";
    homepage = "https://github.com/LoicMarechal/libMeshb";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
})
