{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  cargo,
  rustPlatform,

  withDocs ? true,
  doxygen,
  python3Packages,

  gtest,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libloot";
  version = "0.29.6";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDocs [ "doc" ];

  src = fetchFromGitHub {
    owner = "loot";
    repo = "libloot";
    tag = finalAttrs.version;
    hash = "sha256-Pz13z0uQfTeo47NJORfZ8n8ucqZdoLVGNIsrf2+OOGA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-IQowGdrol/JFoh+hGfhwoJ2FumkvbuZsp8Xx/V2hFdw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cargo
    rustPlatform.cargoSetupHook
  ]
  ++ lib.optionals withDocs [
    doxygen
    python3Packages.sphinx
    python3Packages.sphinx-rtd-theme
    python3Packages.breathe
  ];

  cmakeFlags = [
    (lib.cmakeBool "LIBLOOT_INSTALL_DOCS" withDocs)
    (lib.cmakeBool "LIBLOOT_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ]
  ++ lib.optionals finalAttrs.finalPackage.doCheck [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_TESTING-PLUGINS" "../testing-plugins")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GTEST" "${gtest.src}")
  ];

  preConfigure = ''
    cd cpp
  '';

  testing_plugins = fetchFromGitHub {
    owner = "Ortham";
    repo = "testing-plugins";
    tag = "1.6.2";
    hash = "sha256-3Aa98EwqpuGA3YlsRF8luWzXVEFO/rs6JXisXdLyIK4=";
  };

  postConfigure = lib.optionalString finalAttrs.finalPackage.doCheck ''
    # Some tests fail unless the directory is writable
    cp -r --no-preserve=all "$testing_plugins" ../testing-plugins
  '';

  postBuild = lib.optionalString withDocs ''
    pushd ../../docs
    sphinx-build -b html . build/html
    popd
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    ctest --output-on-failure --parallel
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++ library for accessing LOOT's metadata and sorting functionality";
    homepage = "https://github.com/loot/libloot";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
