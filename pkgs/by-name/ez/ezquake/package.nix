{
  SDL2,
  cmake,
  curlMinimal,
  expat,
  fetchFromGitHub,
  jansson,
  lib,
  libGL,
  libx11,
  libjpeg,
  libpng,
  libsndfile,
  minizip,
  nix-update-script,
  pcre2,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ezquake";
  version = "3.6.8";

  src = fetchFromGitHub {
    owner = "QW-Group";
    repo = "ezquake-source";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-BIkBl6ncwo0NljuqOHJ3yQeDTcClh5FGssdFsKUjN90=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    curlMinimal
    expat
    jansson
    libGL
    libx11
    libjpeg
    libpng
    libsndfile
    minizip
    pcre2
  ];

  enableParallelBuilding = true;

  installPhase =
    let
      sys = lib.last (lib.splitString "-" stdenv.hostPlatform.system);
      arch = lib.head (lib.splitString "-" stdenv.hostPlatform.system);
    in
    ''
      runHook preInstall

      install -D \
        ezquake-${sys}-${arch} $out/bin/${finalAttrs.meta.mainProgram}

      runHook postInstall
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://ezquake.com/";
    description = "Modern QuakeWorld client focused on competitive online play";
    mainProgram = "ezquake";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ edwtjo ];
  };
})
