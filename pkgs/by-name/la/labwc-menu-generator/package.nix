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
  version = "unstable-2023-10-31";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-menu-generator";
    rev = "d7c81071f8b121ef83da32ae3fa16155d1a2ced9";
    hash = "sha256-gZ0TuSVJwcKW4orawSmRQvoCfrpb8yLXlv81qCR86MU=";
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
