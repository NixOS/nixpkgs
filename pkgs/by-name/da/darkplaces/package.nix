{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  libjpeg,
  SDL2,
  libvorbis,
  libx11,
}:
stdenv.mkDerivation {
  pname = "darkplaces";
  version = "20140513-unstable-2026-01-22";

  src = fetchFromGitHub {
    owner = "DarkPlacesEngine";
    repo = "darkplaces";
    rev = "d93f9c4292039354a2b8d40d11bc386891e55fe5";
    hash = "sha256-/xbQhQZveRCSnotZz3Wbw+9VwNC+kqoEJ7GuNZTpkLA=";
  };

  buildInputs = [
    zlib
    libjpeg
    SDL2
    libx11
  ];

  buildFlags = [ "release" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 darkplaces-sdl $out/bin/darkplaces
    install -m755 darkplaces-dedicated $out/bin/darkplaces-dedicated

    runHook postInstall
  '';

  postFixup = ''
    patchelf \
      --add-needed ${libvorbis}/lib/libvorbisfile.so \
      --add-needed ${libvorbis}/lib/libvorbis.so \
      $out/bin/darkplaces
  '';

  meta = {
    homepage = "https://www.icculus.org/twilight/darkplaces/";
    description = "Quake 1 engine implementation by LadyHavoc";
    longDescription = ''
      A game engine based on the Quake 1 engine by id Software.
      It improves and builds upon the original 1996 engine by adding modern
      rendering features, and expanding upon the engine's native game code
      language QuakeC, as well as supporting additional map and model formats.
    '';
    maintainers = with lib.maintainers; [ necrophcodr ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
