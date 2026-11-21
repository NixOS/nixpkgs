{
  lib,
  stdenv,
  cargo,
  cmake,
  common-updater-scripts,
  fetchFromGitHub,
  nix-update,
  qt6,
  ripgrep,
  rustPlatform,
  rustc,
  writeShellScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cutecosmic";
  version = "0.2.0-unstable-2026-11-08";

  src = fetchFromGitHub {
    owner = "IgKh";
    repo = "cutecosmic";
    rev = "707244c52a578d4766205ab4cdb03561cb5b306f";
    hash = "sha256-3/ILsK8PBKjRynZEiGWj6TfvPdXS2UUmnCWo+ZEJdIg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/bindings";
    hash = "sha256-vFShpb87LYOdPR0APgUL0M28nXWN9Gvmf2q45VKwSYA=";
  };

  cargoRoot = "bindings";

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CORROSION" "${finalAttrs.passthru.sources.corrosion}")
  ];

  postPatch = ''
    substituteInPlace platformtheme/CMakeLists.txt \
      --replace-fail "\''${QT_INSTALL_PLUGINS}/platformthemes" \
      "${qt6.qtbase.qtPluginPrefix}/platformthemes"
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${QT_INSTALL_LIBS}/cutecosmic" \
      "${builtins.placeholder "out"}/lib"
  '';

  passthru = {
    sources = {
      # rev from source/bindings/CMakeLists.txt
      corrosion = fetchFromGitHub {
        owner = "corrosion-rs";
        repo = "corrosion";
        rev = "v0.5.2";
        hash = "sha256-sO2U0llrDOWYYjnfoRZE+/ofg3kb+ajFmqvaweRvT7c=";
      };
    };

    updateScript = writeShellScript "update-cutecosmic" ''
      set -euo pipefail

      ${lib.getExe nix-update} cutecosmic --version branch=HEAD
      src=$(nix-build -A cutecosmic.src --no-out-link)

      # Corrosion-rs dependency
      tag=$(${lib.getExe ripgrep} --multiline --pcre2 --only-matching \
        'FetchContent_Declare\(\s*Corrosion[^)]*GIT_TAG\s+(v[\d.]+)' \
        --replace '$1' \
        "$src/bindings/CMakeLists.txt")

      ${lib.getExe' common-updater-scripts "update-source-version"} \
        cutecosmic.sources.corrosion \
        "$tag" \
        --source-key=out \
        --version-key=rev \
        --file=${lib.escapeShellArg (toString ./.) + "/package.nix"}
    '';
  };

  meta = {
    homepage = "https://github.com/IgKh/cutecosmic";
    description = "Qt platform theme for COSMIC Desktop environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      amozeo
      thefossguy
    ];
    platforms = lib.platforms.linux;
  };
})
