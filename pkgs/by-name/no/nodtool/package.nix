{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  git,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nodtool";
  version = "2.0.0-alpha.9";

  src = fetchFromGitHub {
    owner = "encounter";
    repo = "nod";
    tag = "v${finalAttrs.version}";
    hash = "sha256-beWw+OgF4zCepv/7NQiwXOA8qMwMb8Z3C6icywT+Jr0=";
  };

  cargoHash = "sha256-+B7mjiCtuxPQ/zSMy8Lw6r5aGB+PVxhRES6zJhD5NAE=";

  nativeBuildInputs = [
    cmake
    git
  ];

  cargoBuildFlags = [
    "-p"
    "nodtool"
    "-p"
    "nod-ffi"
  ];

  cargoTestFlags = [
    "-p"
    "nodtool"
    "-p"
    "nod-ffi"
  ];

  installPhase = ''
    runHook preInstall

    releaseDir="target/${stdenv.hostPlatform.config}/release"

    install -Dm755 $releaseDir/nodtool -t $out/bin/
    install -Dm755 $releaseDir/libnod${stdenv.hostPlatform.extensions.sharedLibrary} -t $out/lib/
    install -Dm644 $releaseDir/libnod.a -t $out/lib/
    install -Dm644 nod-ffi/include/nod.h -t $out/include/

    cat > gen-cmake-config.cmake <<'EOF'
    include(CMakePackageConfigHelpers)
    set(CMAKE_INSTALL_LIBDIR lib)
    set(CMAKE_INSTALL_INCLUDEDIR include)
    set(CMAKE_INSTALL_BINDIR bin)
    configure_package_config_file("''${NOD_SOURCE_DIR}/cmake/nodConfig.cmake.in" "''${CMAKE_INSTALL_PREFIX}/lib/cmake/nod/nodConfig.cmake" INSTALL_DESTINATION lib/cmake/nod)
    write_basic_package_version_file("''${CMAKE_INSTALL_PREFIX}/lib/cmake/nod/nodConfigVersion.cmake" VERSION "''${NOD_VERSION}" COMPATIBILITY AnyNewerVersion)
    EOF

    cmake \
      ${lib.cmakeFeature "NOD_SOURCE_DIR" "$PWD"} \
      ${lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "$out"} \
      ${lib.cmakeFeature "NOD_VERSION" "2.0.0"} \
      -P gen-cmake-config.cmake

    runHook postInstall
  '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "GameCube/Wii disc image CLI tool and C library";
    homepage = "https://github.com/encounter/nod";
    changelog = "https://github.com/encounter/nod/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "nodtool";
  };
})
