{
  lib,
  stdenv,
  qt6,
  qt5,
  testers,
  alice-tools,
}:
let
  qt = if stdenv.hostPlatform.isDarwin then qt5 else qt6;
  inherit (alice-tools)
    src
    version
    meta
    nativeBuildInputs
    buildInputs
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "alice-tools-gui";
  # nixpkgs-update: no auto update
  inherit src version;

  nativeBuildInputs = nativeBuildInputs ++ [
    qt.wrapQtAppsHook
  ];

  buildInputs = buildInputs ++ [
    qt.qtbase
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    # Use Meson's Qt6 module
    substituteInPlace src/meson.build \
      --replace-fail "qt5" "qt6"
  '';

  # Default install step only installs a static library of a build dependency
  installPhase = ''
    runHook preInstall

    install -Dm755 src/alice $out/bin/alice
    install -Dm755 src/galice $out/bin/galice

    runHook postInstall
  '';

  # versionCheckHook fails here for some reason
  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "env QT_QPA_PLATFORM=minimal " + "${lib.getExe finalAttrs.finalPackage} --version";
  };

  meta = meta // {
    mainProgram = "galice";
  };
})
