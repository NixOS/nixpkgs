{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  zlib,
  libpng,
  libjpeg,
  curl,
  SDL2,
  openalSoft,
  libogg,
  libvorbis,
  libXi,
  wayland,
  wayland-protocols,
  libdecor,
  ffmpeg,
  wayland-scanner,
  makeWrapper,
  versionCheckHook,
  x11Support ? stdenv.hostPlatform.isLinux,
  waylandSupport ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "q2pro";
  version = "3510";

  src = fetchFromGitHub {
    owner = "skullernet";
    repo = "q2pro";
    rev = "refs/tags/r${version}";
    hash = "sha256-LNOrGJarXnf4QqFXDkUfUgLGrjSqbjncpIN2yttbMuk=";
  };

  nativeBuildInputs =
    [
      meson
      pkg-config
      ninja
      makeWrapper
    ]
    ++ lib.optionals waylandSupport [
      wayland-scanner
    ];

  buildInputs =
    [
      zlib
      libpng
      libjpeg
      curl
      SDL2
      libogg
      libvorbis
      ffmpeg
      openalSoft
    ]
    ++ lib.optionals waylandSupport [
      wayland
      wayland-protocols
      libdecor
    ]
    ++ lib.optionals x11Support [ libXi ];

  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonBool "anticheat-server" true)
    (lib.mesonBool "client-gtv" true)
    (lib.mesonBool "packetdup-hack" true)
    (lib.mesonBool "variable-fps" true)
    (lib.mesonEnable "wayland" waylandSupport)
    (lib.mesonEnable "x11" x11Support)
    (lib.mesonEnable "icmp-errors" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "windows-crash-dumps" false)
  ];

  postPatch = ''
    echo 'r${version}' > VERSION
  '';

  postInstall =
    let
      ldLibraryPathEnvName =
        if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
    ''
      mv -v $out/bin/q2pro $out/bin/q2pro-unwrapped
      makeWrapper $out/bin/q2pro-unwrapped $out/bin/q2pro \
        --prefix ${ldLibraryPathEnvName} : "${lib.makeLibraryPath finalAttrs.buildInputs}"
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Enhanced Quake 2 client and server focused on multiplayer";
    homepage = "https://github.com/skullernet/q2pro";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ carlossless ];
    platforms = lib.platforms.unix;
    mainProgram = "q2pro";
  };
})
