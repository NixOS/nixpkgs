{ lib
, stdenv
, fetchFromGitHub
, zlib
, libjpeg
, SDL2
, libvorbis
}:
stdenv.mkDerivation rec {
  pname = "darkplaces";
  version = "unstable-2022-05-10";

  src = fetchFromGitHub {
    owner = "DarkPlacesEngine";
    repo = "darkplaces";
    rev = "f16954a9d40168253ac5d9890dabcf7dbd266cd9";
    hash = "sha256-5KsUcgHbuzFUE6LcclqI8VPSFbXZzBnxzOBB9Kf8krI=";
  };

  buildInputs = [
    zlib
    libjpeg
    SDL2
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

  meta = with lib; {
    homepage = "https://www.icculus.org/twilight/darkplaces/";
    description = "Quake 1 engine implementation by LadyHavoc";
    longDescription = ''
      A game engine based on the Quake 1 engine by id Software.
      It improves and builds upon the original 1996 engine by adding modern
      rendering features, and expanding upon the engine's native game code
      language QuakeC, as well as supporting additional map and model formats.
    '';
    maintainers = with maintainers; [ necrophcodr ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
