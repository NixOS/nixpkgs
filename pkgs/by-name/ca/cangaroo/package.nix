{
  lib,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
  pkg-config,
  libnl,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cangaroo";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "OpenAutoDiagLabs";
    repo = "CANgaroo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5RHcnCCz1iQEZgWuONBixIBZnSz2YsbGsiWPvMBI81s=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libnl
    qt6.qtcharts
    qt6.qtserialport
  ];

  installPhase = ''
    runHook preInstall
    install bin/cangaroo -Dt $out/bin
    substituteInPlace cangaroo.desktop \
      --replace-fail "Exec=/usr/bin/cangaroo" "Exec=$out/bin/cangaroo"
    install cangaroo.desktop -Dt $out/share/applications
    install src/assets/cangaroo.svg -Dt $out/share/icons/hicolor/scalable/apps
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source CAN bus analyzer";
    homepage = "https://github.com/OpenAutoDiagLabs/CANgaroo";
    changelog = "https://github.com/OpenAutoDiagLabs/CANgaroo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    mainProgram = "cangaroo";
    maintainers = with lib.maintainers; [ swendel ];
    platforms = lib.platforms.linux;
  };
})
