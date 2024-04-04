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
  version = "unstable-2024-03-27";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-menu-generator";
    rev = "7b62ce9c25db9ee21c9f93e536615569378bcb20";
    hash = "sha256-CZ+p06D3/Ou29f2RRL9MBvzM+Qisdq0h8ySjzUqhGZM=";
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
