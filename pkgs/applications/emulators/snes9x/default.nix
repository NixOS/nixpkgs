{ lib
, stdenv
, alsa-lib
, fetchFromGitHub
, gtkmm3
, libepoxy
, libpng
, libX11
, libXv
, libXext
, libXinerama
, meson
, minizip
, ninja
, pkg-config
, portaudio
, pulseaudio
, SDL2
, wrapGAppsHook
, zlib
, withGtk ? false
}:

stdenv.mkDerivation rec {
  pname =
    if withGtk then
      "snes9x-gtk"
    else
      "snes9x";
  version = "1.61";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    rev = version;
    fetchSubmodules = true;
    sha256 = "1kay7aj30x0vn8rkylspdycydrzsc0aidjbs0dd238hr5hid723b";
  };

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals withGtk [
    meson
    ninja
    wrapGAppsHook
  ];

  buildInputs = [
    libX11
    libXext
    libXv
    minizip
    zlib
  ]
  # on non-Linux platforms this will build without sound support on X11 build
  ++ lib.optionals stdenv.isLinux [
    alsa-lib
    pulseaudio
  ]
  ++ lib.optionals (!withGtk) [
    libpng
    libXinerama
  ]
  ++ lib.optionals withGtk [
    gtkmm3
    libepoxy
    portaudio
    SDL2
  ];

  configureFlags =
    lib.optional stdenv.hostPlatform.sse4_1Support "--enable-sse41"
    ++ lib.optional stdenv.hostPlatform.avx2Support "--enable-avx2"
    ++ lib.optional stdenv.hostPlatform.isAarch64 "--enable-neon";

  installPhase = lib.optionalString (!withGtk) ''
    runHook preInstall

    install -Dm755 snes9x -t "$out/bin/"
    install -Dm644 snes9x.conf.default -t "$out/share/doc/${pname}/"
    install -Dm644 ../docs/{control-inputs,controls,snapshots}.txt -t \
      "$out/share/doc/${pname}/"

    runHook postInstall
  '';

  preConfigure =
    if withGtk then
      "cd gtk"
    else
      "cd unix";

  enableParallelBuilding = true;

  meta = with lib;
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

      license = licenses.unfreeRedistributable // {
        url = "https://github.com/snes9xgit/snes9x/blob/${version}/LICENSE";
      };
      maintainers = with maintainers; [ qknight xfix thiagokokada ];
      platforms = platforms.unix;
      broken = (withGtk && stdenv.isDarwin);
    };
}
