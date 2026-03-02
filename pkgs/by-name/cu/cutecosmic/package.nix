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
  version = "0.1-unstable-2026-01-21";

  src = fetchFromGitHub {
    owner = "IgKh";
    repo = "cutecosmic";
    rev = "8e584418f69eeeaee8574c4a48cc92ef27fd610e";
    hash = "sha256-jKiO+WlNHM1xavKdB6PrGd3HmTgnyL1vjh0Ps1HcWx4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    sourceRoot = "${finalAttrs.src.name}/bindings";
    hash = "sha256-+1z0VoxDeOYSmb7BoFSdrwrfo1mmwkxeuEGP+CGFc8Y=";
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
