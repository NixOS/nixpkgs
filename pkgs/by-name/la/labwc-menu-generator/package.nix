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
  version = "0-unstable-2024-05-27";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-menu-generator";
    rev = "efed0194947c45123287ea057c5fdb13894854cd";
    hash = "sha256-ZmuntI3NfIYkM2Fxt3J4pKOOilzgphF240mCer3cJ6c=";
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
