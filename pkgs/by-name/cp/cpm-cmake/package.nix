{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cpm-cmake";
  version = "0.40.3";

  src = fetchFromGitHub {
    owner = "cpm-cmake";
    repo = "cpm.cmake";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3V4XLfhDy6TIOcfSJjkvTRCxo/e5/Kt/+xxAXlZo0XM=";
  };

  postPatch = ''
    substituteInPlace cmake/CPM.cmake \
      --replace-fail "set(CURRENT_CPM_VERSION 1.0.0-development-version)" "set(CURRENT_CPM_VERSION ${finalAttrs.version})"
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{,doc/}cpm
    install -Dm644 cmake/CPM.cmake $out/share/cpm/CPM.cmake
    install -Dm644 README.md CONTRIBUTING.md $out/share/doc/cpm/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/cpm-cmake/CPM.cmake";
    description = "CMake's missing package manager";
    longDescription = ''
      CPM.cmake is a cross-platform CMake script that adds dependency
      management capabilities to CMake. It's built as a thin wrapper around
      CMake's FetchContent module that adds version control, caching, a
      simple API and more.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.all;
  };
})
