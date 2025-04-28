{
  lib,
  rustPlatform,
  fetchCrate,
  kdePackages,
  libGL,
  nix-update-script,
  versionCheckHook,
  withQt6Support ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "slint-viewer";
  version = "1.10.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-i6JB/bc8lQE9K9Jy1mUz2I/LKIoEtc/dgJzsQTcEXeQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fXREHHPR2CZtyvvOdL5wKnkmT1q9Xj+ik2lR/52ApLI=";

  CXXFLAGS = lib.optionals withQt6Support [
    "-I ${lib.getDev libGL}/include"
  ];

  nativeBuildInputs = lib.optionals withQt6Support (
    with kdePackages;
    [
      qtbase
      qtsvg
      wrapQtAppsHook
    ]
  );

  # There are no tests
  doCheck = false;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Viewer for .slint files from the Slint Project";
    mainProgram = "slint-viewer";
    homepage = "https://github.com/slint-ui/slint/tree/master/tools/viewer";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ dtomvan ];
  };
})
