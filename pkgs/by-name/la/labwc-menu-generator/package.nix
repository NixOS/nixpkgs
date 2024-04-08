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
  version = "unstable-2024-03-12";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-menu-generator";
    rev = "85a014db7214103c14c2bfbb5fc09a349ad64992";
    hash = "sha256-nt/K00cr1dKEk547J/6w1j6O3WSgGqVt1+Jdw95K28s=";
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
