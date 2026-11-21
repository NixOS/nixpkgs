{
  lib,
  stdenv,
  bash,
  cmake,
  coreutils,
  fetchFromGitHub,
  grim,
  hyprland,
  kdePackages,
  ninja,
  pkg-config,
  tesseract,
  wayland,
  wayland-protocols,
  wl-clipboard,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "omasnap";
  version = "1.12.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tobi";
    repo = "omasnap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5xmgIOFzvStMRpzgMy8fBdm34UVrCATYT+s+ZAR/odc=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/usr/share/wayland-protocols" \
        "${wayland-protocols}/share/wayland-protocols"
    substituteInPlace transform-smoke.cpp \
      --replace-fail "/usr/bin/env bash" "${coreutils}/bin/env bash"
  '';

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
    ninja
    pkg-config
    wayland
  ];

  buildInputs = [
    kdePackages.layer-shell-qt
    kdePackages.qtbase
    wayland
  ];

  nativeCheckInputs = [
    bash
    coreutils
    tesseract
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    QT_QPA_PLATFORM=offscreen ./omasnap-smoke "$TMPDIR/omasnap-smoke"
    runHook postCheck
  '';

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      grim
      hyprland
      tesseract
      wl-clipboard
    ])
  ];

  meta = {
    description = "Fast native Wayland screenshot and annotation overlay for Hyprland";
    homepage = "https://github.com/tobi/omasnap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yechielw ];
    mainProgram = "omasnap";
    platforms = lib.platforms.linux;
  };
})
