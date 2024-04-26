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
  qt6,
  stdenv,
  unstableGitUpdater,
  util-linuxMinimal,
  wayland,
  wrapGAppsHook,
  zlib,
  # Boolean flags
  interface ? "x11",
}:

assert lib.elem interface [ "gtk" "qt" "x11" "macos" ];
assert (interface == "macos") -> stdenv.isDarwin;
stdenv.mkDerivation (finalAttrs: {
  pname = "snes9x-${interface}";
  version = "1.62.3-unstable-2024-04-22";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    rev = "582128bce7ccf4e3cf7848ae9f6a729a1ebad4c4";
    fetchSubmodules = true;
    hash = "sha256-fJ1g/L7oA9bhEawTsWjfLl1dDIKEGI+pcpWQCTutyR8=";
  };

  nativeBuildInputs = [
    SDL2
    pkg-config
    python3
  ]
  ++ lib.optionals (interface == "gtk" || interface == "qt") [
    cmake
    ninja
  ]
  ++ lib.optionals (interface == "qt") [
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals (interface == "gtk") [
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
  ++ lib.optionals (interface == "x11") [
    libpng
    libXext
    libXinerama
  ]
  ++ lib.optionals (interface == "qt") [
    qt6.qtbase
    wayland
  ]
  ++ lib.optionals (interface == "gtk") [
    gtkmm3
    libepoxy
    libXdmcp
    libXrandr
    pcre2
    portaudio
    SDL2
  ];

  strictDeps = true;

  hardeningDisable = [ "format" ];

  configureFlags = lib.optionals stdenv.hostPlatform.sse4_1Support [
    "--enable-sse41"
  ]
  ++ lib.optionals stdenv.hostPlatform.avx2Support [
    "--enable-avx2"
  ];

  preConfigure = let
    directory = {
      "gtk" = "gtk";
      "macos" = "macos";
      "qt" = "qt";
      "x11" = "unix";
    }.${interface};
  in ''
    cd ${directory}
  '';

  installPhase = lib.optionalString (interface == "x11") ''
    runHook preInstall

    install -Dm755 snes9x -t "$out/bin/"
    install -Dm644 snes9x.conf.default -t "$out/share/doc/${finalAttrs.pname}/"
    install -Dm644 ../docs/{control-inputs,controls,snapshots}.txt -t \
      "$out/share/doc/${finalAttrs.pname}/"

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater {};
  };

  meta =
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
      broken = (interface == "gtk" && stdenv.isDarwin)
               # [ AndersonTorres ] qt has no native install phase
               || (interface == "qt")
               # [ AndersonTorres ] I don't have a Darwin machine to play with
               || (interface == "macos");
    };
})
