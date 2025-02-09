{ stdenv
, lib
, fetchFromGitHub
, gitUpdater
, cmake
, SDL2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nuked-md";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "nukeykt";
    repo = "Nuked-MD";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Pe+TSu9FBUhxtACq+6jMbrUxiwKLOJgQbEcmUrcrjMs=";
  };

  # Interesting detail about our SDL2 packaging:
  # Because we build it with the configure script instead of CMake, we ship sdl2-config.cmake instead of SDL2Config.cmake
  # The former doesn't set SDL2_FOUND while the latter does (like CMake config scripts should), which causes this issue:
  #
  # CMake Error at CMakeLists.txt:5 (find_package):
  #   Found package configuration file:
  #
  #     <SDL2.dev>/lib/cmake/SDL2/sdl2-config.cmake
  #
  #   but it set SDL2_FOUND to FALSE so package "SDL2" is considered to be NOT
  #   FOUND.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'SDL2 REQUIRED' 'SDL2'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    SDL2
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 Nuked-MD $out/bin/Nuked-MD

    runHook postInstall
  '';

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    description = "Cycle accurate Mega Drive emulator";
    longDescription = ''
      Cycle accurate Mega Drive core. The goal of this project is to emulate Sega Mega Drive chipset as accurately as
      possible using decapped chips photos.
    '';
    homepage = "https://github.com/nukeykt/Nuked-MD";
    license = licenses.gpl2Plus;
    mainProgram = "Nuked-MD";
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
})
