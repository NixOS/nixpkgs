{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prometheus-cpp-lite";
  version = "1.0-unstable-2023-08-13";

  src = fetchFromGitHub {
    owner = "biaks";
    repo = "prometheus-cpp-lite";
    rev = "48d09c45ee6deb90e02579b03037740e1c01fd27";
    hash = "sha256-XplbP4wHxK9z8Q5fOnaiL7vzXBaZTJyo/tmXUJN/mb4=";
  };

  patches = [
    ./missing_includes.patch
  ];

  postPatch = ''
    for dir in . core simpleapi; do
    substituteInPlace $dir/CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 3.2)' \
      'cmake_minimum_required(VERSION 3.10)'
    done

    substituteInPlace 3rdpatry/http-client-lite/CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 3.3 FATAL_ERROR)' \
      'cmake_minimum_required(VERSION 3.10)' \
  '';

  nativeBuildInputs = [
    cmake
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include/prometheus $out/lib

    cp ../core/include/prometheus/* $out/include/prometheus
    cp ../simpleapi/include/prometheus/* $out/include/prometheus
    cp simpleapi/libprometheus-cpp-simpleapi.* $out/lib/

    runHook postInstall
  '';

  meta = {
    description = "C++ Header-only Prometheus client library";
    homepage = "https://github.com/biaks/prometheus-cpp-lite";
    maintainers = [ lib.maintainers.markuskowa ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
