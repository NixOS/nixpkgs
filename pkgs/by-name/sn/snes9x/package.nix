{
  lib,
  SDL2,
  alsa-lib,
  cmake,
  fetchFromGitHub,
  gtkmm3,
  libGLX,
  libX11,
  libXdmcp,
  libXext,
  libXinerama,
  libXrandr,
  libXv,
  libepoxy,
  libpng,
  libselinux,
  minizip,
  ninja,
  pcre2,
  pkg-config,
  portaudio,
  pulseaudio,
  python3,
  stdenv,
  util-linuxMinimal,
  wrapGAppsHook3,
  zlib,
  # Boolean flags
  withGtk ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snes9x" + lib.optionalString withGtk "-gtk";
  version = "1.63";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-INMVyB3alwmsApO7ToAaUWgh7jlg2MeLxqHCEnUO88U=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
  ]
  ++ lib.optionals withGtk [
    cmake
    ninja
    wrapGAppsHook3
  ];

  buildInputs = [
    libX11
    libXv
    minizip
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    pulseaudio
    libselinux
    util-linuxMinimal # provides libmount
  ]
  ++ lib.optionals (!withGtk) [
    libpng
    libXext
    libXinerama
  ]
  ++ lib.optionals withGtk [
    gtkmm3
    libepoxy
    libXdmcp
    libXrandr
    pcre2
    portaudio
    SDL2
  ];

  hardeningDisable = [ "format" ];

  configureFlags =
    lib.optionals stdenv.hostPlatform.sse4_1Support [
      "--enable-sse41"
    ]
    ++ lib.optionals stdenv.hostPlatform.avx2Support [
      "--enable-avx2"
    ];

  postPatch = lib.optionalString withGtk ''
    substituteInPlace external/glad/src/egl.c \
      --replace-fail libEGL.so.1 "${lib.getLib libGLX}/lib/libEGL.so.1"
    substituteInPlace external/glad/src/glx.c \
      --replace-fail libGL.so.1 ${lib.getLib libGLX}/lib/libGL.so.1
  '';

  preConfigure = ''
    cd ${if withGtk then "gtk" else "unix"}
  '';

  installPhase = lib.optionalString (!withGtk) ''
    runHook preInstall

    install -Dm755 snes9x -t "$out/bin/"
    install -Dm644 snes9x.conf.default -t "$out/share/doc/snes9x/"
    install -Dm644 ../docs/{control-inputs,controls,snapshots}.txt -t \
      "$out/share/doc/snes9x/"

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta =
    let
      interface = if withGtk then "GTK" else "X11";
    in
    {
      homepage = "https://www.snes9x.com";
      description = "Super Nintendo Entertainment System (SNES) emulator, ${interface} version";
      longDescription = ''
        Snes9x is a portable, freeware Super Nintendo Entertainment System (SNES)
        emulator. It basically allows you to play most games designed for the SNES
        and Super Famicom Nintendo game systems on your PC or Workstation; which
        includes some real gems that were only ever released in Japan.

        Version build with ${interface} interface.
      '';
      license = lib.licenses.unfreeRedistributable // {
        url = "https://github.com/snes9xgit/snes9x/blob/${finalAttrs.src.tag}/LICENSE";
      };
      mainProgram = "snes9x";
      maintainers = with lib.maintainers; [
        qknight
        thiagokokada
        sugar700
      ];
      platforms = lib.platforms.unix;
      broken = (withGtk && stdenv.hostPlatform.isDarwin);
    };
})
