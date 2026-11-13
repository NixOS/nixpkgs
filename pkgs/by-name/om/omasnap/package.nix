{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  pkg-config,
  kdePackages,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libdeflate,
  tesseract,
  wl-clipboard,
  liberation_ttf,
  coreutils,
  bash,
  makeFontsConf,
  fontconfig,
  versionCheckHook,
  nix-update-script,
}:

let
  tesseractWithData = tesseract.override { enableLanguages = [ "eng" ]; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "omasnap";
  version = "1.26.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "omasnap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TIWdeuhUazciLUf2Nd9iEafyarM1cp7MlKHnflq6FUg=";
  };

  postPatch = ''
    # Upstream hardcodes /usr/share/wayland-protocols; submitted upstream in https://github.com/omacom/omasnap/pull/232
    substituteInPlace CMakeLists.txt \
      --replace-fail "/usr/share/wayland-protocols" \
        "${wayland-protocols}/share/wayland-protocols"

    # Smoke tests invoke /bin/cat and /usr/bin/env bash directly, which do not exist in the Nix build sandbox.
    substituteInPlace tests/pin-interaction-smoke.cpp \
      --replace-fail "/bin/cat" "${lib.getExe' coreutils "cat"}"

    substituteInPlace \
      tests/transform-smoke.cpp \
      tests/clipboard-smoke.cpp \
      tests/editor-smoke.cpp \
      --replace-fail "/usr/bin/env bash" "${lib.getExe bash}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.wrapQtAppsHook
    wayland-scanner
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.layer-shell-qt
    wayland
    libdeflate
  ];

  cmakeFlags = [
    (lib.cmakeFeature "OMASNAP_VERSION" finalAttrs.version)
  ];

  nativeCheckInputs = [
    ctestCheckHook
    tesseractWithData
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export HOME=$(mktemp -d)
    export XDG_RUNTIME_DIR=$(mktemp -d)
    chmod 0700 "$XDG_RUNTIME_DIR"
    export OMASNAP_RECENT_DIR=$(mktemp -d)
    chmod 0700 "$OMASNAP_RECENT_DIR"
    export FONTCONFIG_FILE=${
      makeFontsConf {
        fontDirectories = [ liberation_ttf ];
        includes = [ "${fontconfig.out}/etc/fonts/conf.d" ];
      }
    }
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  versionCheckKeepEnvironment = [ "QT_QPA_PLATFORM" ];

  preInstallCheck = ''
    export QT_QPA_PLATFORM=offscreen
  '';

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      tesseractWithData
      wl-clipboard
    ])
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast native Wayland screenshot and annotation overlay for Hyprland";
    homepage = "https://github.com/omacom/omasnap";
    changelog = "https://github.com/omacom/omasnap/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      ofl
      isc
    ];
    maintainers = with lib.maintainers; [
      yechielw
      kleinbem
    ];
    mainProgram = "omasnap";
    platforms = lib.platforms.linux;
  };
})
