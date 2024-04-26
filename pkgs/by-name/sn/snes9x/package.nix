{
  lib,
  SDL2,
  alsa-lib,
  cmake,
  fetchFromGitHub,
  gtkmm3,
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
  wrapGAppsHook,
  zlib,
  # Boolean flags
  withGtk ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snes9x" + lib.optionalString withGtk "-gtk";
  version = "1.62.3-unstable-2024-04-22";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    rev = "582128bce7ccf4e3cf7848ae9f6a729a1ebad4c4";
    fetchSubmodules = true;
    hash = "sha256-fJ1g/L7oA9bhEawTsWjfLl1dDIKEGI+pcpWQCTutyR8=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
  ]
  ++ lib.optionals withGtk [
    cmake
    ninja
    wrapGAppsHook
  ];

  buildInputs = [
    libX11
    libXv
    minizip
    zlib
  ]
  ++ lib.optionals stdenv.isLinux [
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

  configureFlags = lib.optionals stdenv.hostPlatform.sse4_1Support [
    "--enable-sse41"
  ]
  ++ lib.optionals stdenv.hostPlatform.avx2Support [
    "--enable-avx2"
  ];

  preConfigure = ''
    cd ${if withGtk then "gtk" else "unix"}
  '';

  installPhase = lib.optionalString (!withGtk) ''
    runHook preInstall

    install -Dm755 snes9x -t "$out/bin/"
    install -Dm644 snes9x.conf.default -t "$out/share/doc/${finalAttrs.pname}/"
    install -Dm644 ../docs/{control-inputs,controls,snapshots}.txt -t \
      "$out/share/doc/${finalAttrs.pname}/"

    runHook postInstall
  '';

  meta = let
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
        url = "https://github.com/snes9xgit/snes9x/blob/${finalAttrs.src.rev}/LICENSE";
      };
      mainProgram = "snes9x";
      maintainers = with lib.maintainers; [
        AndersonTorres
        qknight
        thiagokokada
      ];
      platforms = lib.platforms.unix;
      broken = (withGtk && stdenv.isDarwin);
    };
})
