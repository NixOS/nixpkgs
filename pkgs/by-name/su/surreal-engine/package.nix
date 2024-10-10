{
  alsa-lib,
  cmake,
  dbus,
  fetchFromGitHub,
  lib,
  makeWrapper,
  openal,
  pkg-config,
  SDL2,
  stdenv,
  vulkan-loader,
  waylandpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "surreal-engine";
  version = "2024-08-31";

  src = fetchFromGitHub {
    owner = "dpjudas";
    repo = "SurrealEngine";
    rev = "784a2707fba5dc641bee85cc48e7e15dc7585044";
    hash = "sha256-7k7/G+qIIVCxKZQUtQ31MODdN4bU2bP1PYgv6r6laUE=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    alsa-lib
    dbus
    openal
    SDL2
    vulkan-loader
    waylandpp
  ];

  cmakeBuildType = "Release";
  parallelBuild = true;

  postPatch = ''
    substituteInPlace SurrealEngine/UI/WidgetResourceData.cpp --replace-fail /usr/share $out/share
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin Surreal{Debugger,Editor,Engine}
    install -Dt $out/share/surrealengine SurrealEngine.pk3

    runHook postInstall
  '';

  postFixup = ''
    for bin in $out/bin/Surreal{Debugger,Editor,Engine}; do
      wrapProgram $bin --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
    done
  '';

  meta = with lib; {
    description = "Reimplementation of the original Unreal Engine";
    mainProgram = "SurrealEngine";
    homepage = "https://github.com/dpjudas/SurrealEngine";
    license = licenses.zlib;
    maintainers = with maintainers; [ hughobrien ];
    platforms = platforms.linux;
  };
})
