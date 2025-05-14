{
  alsa-lib,
  cmake,
  dbus,
  fetchFromGitHub,
  lib,
  libffi,
  makeWrapper,
  openal,
  pkg-config,
  SDL2,
  libX11,
  stdenv,
  vulkan-loader,
  wayland,
  waylandpp,
  libxkbcommon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "surreal-engine";
  version = "0-unstable-2024-11-08";

  src = fetchFromGitHub {
    owner = "dpjudas";
    repo = "SurrealEngine";
    rev = "087fa2af7fd0ce51702dd4024b4ae15a88222678";
    hash = "sha256-AEIBhTkkRq4+L4ycx82GE29dM7zNgE0oHOkwEH9ezUg=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    dbus
    libffi
    openal
    SDL2
    libX11
    vulkan-loader
    wayland
    waylandpp
    libxkbcommon
  ];

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
