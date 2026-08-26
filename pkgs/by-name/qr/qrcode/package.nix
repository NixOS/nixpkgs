{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qrcode";
  version = "0-unstable-2025-04-29";

  src = fetchFromGitHub {
    owner = "qsantos";
    repo = "qrcode";
    rev = "29140c67b69b79e5c8a52911489648853fddf85f";
    hash = "sha256-WQeZB8G9Nm68mYmLr0ksZdFDcQxF54X0yJxigJZWvMo=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  # Upstream Makefile has no install target.
  installPhase = ''
    runHook preInstall
    install -Dm755 qrcode -t "$out/bin"
    install -Dm644 DOCUMENTATION LICENCE -t "$out/share/doc/qrcode"
    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      # Upstream exits non-zero even on successful -V.
      command = "{ qrcode -V || true; }";
      version = "0.1";
    };
  };

  meta = {
    description = "QR-code encoder and decoder";
    homepage = "https://github.com/qsantos/qrcode";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      raskin
      lucasew
    ];
    platforms = lib.platforms.unix;
    mainProgram = "qrcode";
  };
})
