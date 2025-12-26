{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  cmake,
  copyDesktopItems,
  deutex,
  makeDesktopItem,
  makeWrapper,
  pkg-config,
  wrapGAppsHook3,

  SDL2,
  SDL2_mixer,
  SDL2_net,
  alsa-lib,
  cpptrace,
  curl,
  expat,
  fltk,
  libdwarf,
  libselinux,
  libsepol,
  libsysprof-capture,
  libuuid,
  libxdmcp,
  libxkbcommon,
  pcre2,
  portmidi,
  wayland-scanner,
  waylandpp,
  wxGTK32,
  xorg,
  zstd,

  nix-update-script,

  withX11 ? stdenv.hostPlatform.isLinux,
  withWayland ? stdenv.hostPlatform.isLinux,
}:

let
  # TODO: remove when this is resolved, likely at the next cpptrace bump
  cpptrace' = cpptrace.overrideAttrs {
    # tests are failing on darwin
    # https://hydra.nixos.org/build/310535948
    doCheck = !stdenv.hostPlatform.isDarwin;
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "odamex";
  version = "11.2.0";

  src = fetchFromGitHub {
    owner = "odamex";
    repo = "odamex";
    tag = finalAttrs.version;
    hash = "sha256-f9st852Sqmdmb/qNP1ioBY9MApt9Ruw8dBjkkyGM5Qs=";
    fetchSubmodules = true;
  };

  patches = [
    # fix file-open panel on Darwin
    # https://github.com/odamex/odamex/pull/1402
    # TODO: remove on next release
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/odamex/odamex/pull/1402.patch";
      hash = "sha256-JrcQ0rYkaFP5aKNWeXbrY2TN4r8nHpue19qajNXJXg4=";
    })
  ];

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    deutex
    makeWrapper
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    SDL2_net
    cpptrace'
    curl
    expat
    fltk
    libdwarf
    libsysprof-capture
    pcre2
    portmidi
    wxGTK32
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libselinux
    libuuid
    libxdmcp
    libsepol
  ]
  ++ lib.optionals withX11 [
    xorg.libX11
    xorg.xorgproto
  ]
  ++ lib.optionals withWayland [
    libxkbcommon
    wayland-scanner
    waylandpp
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_INTERNAL_CPPTRACE" false)
    (lib.cmakeFeature "ODAMEX_INSTALL_BINDIR" "$ODAMEX_BINDIR") # set by wrapper
  ];

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        # bash
        ''
          mkdir -p $out/{Applications,bin}

          mv client odamex
          for name in odamex odalaunch; do
            contents="Applications/$name.app/Contents/MacOS"
            mv $name/*.app $out/Applications
            makeWrapper $out/{"$contents",bin}/"$name" \
              --set ODAMEX_BINDIR "${placeholder "out"}/Applications"
          done

          cp server/odasrv $out/Applications
          ln -s $out/Applications/odamex.app/Contents/MacOS/odamex.wad $out/Applications
          makeWrapper $out/{Applications,bin}/odasrv
        ''
      else
        # bash
        ''
          make install

          # copy desktop file icons
          for name in odamex odalaunch odasrv; do
            for size in 96 128 256 512; do
              install -Dm644 ../media/icon_"$name"_"$size".png \
                $out/share/icons/hicolor/"$size"x"$size"/"$name".png
            done

            install -Dm644 ../media/icon_"$name"_128.png \
              $out/share/pixmaps/"$name".png
          done
        ''
    }

    runHook postInstall
  '';

  preFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    gappsWrapperArgs+=(
      --set ODAMEX_BINDIR "${placeholder "out"}/bin"
    )
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "odamex";
      icon = "odamex";
      exec = "odamex";
      desktopName = "Odamex Client";
      comment = "A Doom multiplayer game engine";
      categories = [
        "ActionGame"
        "Game"
        "Shooter"
      ];
    })
    (makeDesktopItem {
      name = "odalaunch";
      icon = "odalaunch";
      exec = "odalaunch";
      desktopName = "Odamex Launcher";
      comment = "Server Browser for Odamex";
      categories = [
        "ActionGame"
        "Game"
        "Shooter"
      ];
    })
    (makeDesktopItem {
      name = "odasrv";
      icon = "odasrv";
      exec = "odasrv";
      desktopName = "Odamex Server";
      comment = "Run an Odamex game server";
      categories = [
        "Network"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "http://odamex.net/";
    description = "Client/server port for playing old-school Doom online";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "odalaunch";
  };
})
