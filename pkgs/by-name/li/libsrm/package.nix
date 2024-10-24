{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "libsrm";
  version = "0-unstable-2020-11-05";

  src = fetchFromGitHub {
    owner = "ka-petrov";
    repo = "LibSRM";
    rev = "7db2df68147ea07c93be0973fb04da7e4bbdaa11";
    hash = "sha256-FYKlu9MqXjVr6eiHYOPsypypXmQtC8mlfCf0G9Lbt94=";
  };

  sourceRoot = "${finalAttrs.src.name}/libsrm";

  postPatch = ''
    echo "install(TARGETS srm DESTINATION lib)" >> CMakeLists.txt
    echo "install(TARGETS srm_test DESTINATION bin)" >> CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "C++ implementation of the statistical region merging algorithm";
    homepage = "https://github.com/ka-petrov/LibSRM";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
