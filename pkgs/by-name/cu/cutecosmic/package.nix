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
  version = "0.2.0-unstable-2026-08-15";

  src = fetchFromGitHub {
    owner = "IgKh";
    repo = "cutecosmic";
    rev = "5fa7c228ce04c5310c61dd975e940397711e3cef";
    hash = "sha256-OjoJ7z8HZmyrd7UTZJ3n1jqGRTSuN0PviOwHl5WwJZw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/bindings";
    hash = "sha256-WInS4yY43OlRzGLXYdXUlelzpm+sjBHiyfQNQ+IAM8M=";
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
