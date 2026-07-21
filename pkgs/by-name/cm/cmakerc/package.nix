{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cmrc";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "vector-of-bool";
    repo = "cmrc";
    rev = finalAttrs.version;
    hash = "sha256-++16WAs2K9BKk8384yaSI/YD1CdtdyXVBIjGhqi4JIk=";
  };

  # Fix the cmake_minimum_required version constraint in CMakeRC.cmake.
  patches = [
    ./0001-Fix-minimum-required-CMake-version-to-be-compatible-.patch
  ];

  installPhase = ''
    runHook preInstall

    install CMakeRC.cmake -DT $out/share/cmakerc/cmakerc-config.cmake

    runHook postInstall
  '';

  meta = {
    description = "Resource Compiler in a Single CMake Script";
    homepage = "https://github.com/vector-of-bool/cmrc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guekka ];
    platforms = lib.platforms.all;
  };
})
