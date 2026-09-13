{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kripton";
  version = "0-unstable-2026-02-16";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "Kripton";
    rev = "5e0f2e79ea9cc44c01da49457b26ea92924207c6";
    hash = "sha256-QC3ZgDmqoKiltJ02wP9KdOHmMb6mfGLRW0+YB4e0mms=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/Kripton
    cp -a ./* $out/share/themes/Kripton
    runHook postInstall
  '';

  meta = {
    description = "A dark theme with flat style for GNOME";
    homepage = "https://github.com/EliverLara/Kripton";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "kripton";
    platforms = lib.platforms.all;
  };
})
