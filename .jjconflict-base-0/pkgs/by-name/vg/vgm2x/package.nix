{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  libarchive,
  libzip,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vgm2x";
  version = "0-unstable-2024-06-18";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "vgm2x";
    rev = "1c379d74d2365d4478abe25a12572f357d35d576";
    fetchSubmodules = true;
    hash = "sha256-lWyOyaV9dDrvGfmCE7m5M8DsxcB8bzJ35Amj3DAOVeA=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'pkg-config' "$PKG_CONFIG"
  '';

  strictDeps = true;

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libarchive
    libzip
  ];

  buildFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 vgm2x $out/bin/vgm2x

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "VGM file extraction tools";
    homepage = "https://github.com/vampirefrog/vgm2x";
    license = lib.licenses.gpl3Only;
    mainProgram = "vgm2x";
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
})
