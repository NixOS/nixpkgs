{ lib
, stdenv
, fetchFromGitHub
, glib
, perl
, pkg-config
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labwc-menu-generator";
  version = "unstable-2024-03-11";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-menu-generator";
    rev = "38d08a6695fe9d3176059dc5c57a9c84f9ef4981";
    hash = "sha256-wB5+VmtxjuWbeuDdtGt0f9u7bc3j1Bb6r5MfmMsmE0M=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  nativeCheckInputs = [
    perl
  ];

  doCheck = true;

  strictDeps = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 labwc-menu-generator -t $out/bin
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/labwc/labwc-menu-generator";
    description = "Menu generator for labwc";
    mainProgram = "labwc-menu-generator";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ AndersonTorres romildo ];
  };
})
