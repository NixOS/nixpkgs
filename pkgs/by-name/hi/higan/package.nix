{
  lib,
  SDL2,
  alsa-lib,
  fetchFromGitHub,
  gtk3,
  gtksourceview3,
  libGL,
  libGLU,
  libX11,
  libXv,
  libao,
  libicns,
  libpulseaudio,
  openal,
  installShellFiles,
  pkg-config,
  runtimeShell,
  stdenv,
  udev,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "higan";
  version = "115-unstable-2024-09-04";

  src = fetchFromGitHub {
    owner = "higan-emu";
    repo = "higan";
    rev = "a03b2e94c620eb12ab6f9936aee50e4389bee2ff";
    hash = "sha256-VpwHjA0LufKDnGRAS906Qh3R2pVt4uUGXxsRcca9SyM=";
  };

  nativeBuildInputs =
    [
      installShellFiles
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libicns
    ];

  buildInputs =
    [
      SDL2
      libao
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      gtk3
      gtksourceview3
      libGL
      libGLU
      libX11
      libXv
      libpulseaudio
      openal
      udev
    ];

  patches = [
    # Includes cmath header
    ./patches/0001-include-cmath.patch
    # Uses png2icns instead of sips
    ./patches/0002-sips-to-png2icns.patch
  ];

  dontConfigure = true;

  enableParallelBuilding = true;

  buildPhase =
    let
      platform =
        if stdenv.hostPlatform.isLinux then
          "linux"
        else if stdenv.hostPlatform.isDarwin then
          "macos"
        else if stdenv.hostPlatform.isBSD then
          "bsd"
        else if stdenv.hostPlatform.isWindows then
          "windows"
        else
          throw "Unknown platform for higan: ${stdenv.hostPlatform.system}";
    in
    ''
      runHook preBuild

      make -C higan-ui -j$NIX_BUILD_CORES \
        compiler=${stdenv.cc.targetPrefix}c++ \
        platform=${platform} \
        openmp=true \
        hiro=gtk3 \
        build=accuracy \
        local=false \
        cores="cv fc gb gba md ms msx ngp pce sfc sg ws"

      make -C icarus -j$NIX_BUILD_CORES \
        compiler=${stdenv.cc.targetPrefix}c++ \
        platform=${platform} \
        openmp=true \
        hiro=gtk3

      runHook postBuild
    '';

  installPhase =
    ''
      runHook preInstall

    ''
    + (
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir $out
          mv higan/out/higan.app $out/
          mv icarus/out/icarus.app $out/
        ''
      else
        ''
          installBin higan-ui/out/higan icarus/out/icarus

          install -d $out/share/applications
          install higan-ui/resource/higan.desktop -t $out/share/applications/
          install icarus/resource/icarus.desktop -t $out/share/applications/

          install -d $out/share/pixmaps
          install higan/higan/resource/higan.svg $out/share/pixmaps/higan-icon.svg
          install higan/higan/resource/logo.png $out/share/pixmaps/higan-icon.png
          install icarus/resource/icarus.svg $out/share/pixmaps/icarus-icon.svg
          install icarus/resource/icarus.png $out/share/pixmaps/icarus-icon.png
        ''
    )
    + ''
      install -d $out/share/higan
      cp -rd extras/ higan/System/ $out/share/higan/

      install -d $out/share/icarus
      cp -rd icarus/Database icarus/Firmware $out/share/icarus/
    ''
    + (
      # A dirty workaround, suggested by @cpages:
      # we create a first-run script to populate
      # $HOME with all the stuff needed at runtime
      let
        dest =
          if stdenv.hostPlatform.isDarwin then
            "\\$HOME/Library/Application Support/higan"
          else
            "\\$HOME/higan";
      in
      ''
        mkdir -p $out/bin
        cat <<EOF > $out/bin/higan-init.sh
        #!${runtimeShell}

        cp --recursive --update $out/share/higan/System/ "${dest}"/

        EOF

        chmod +x $out/bin/higan-init.sh
      ''
    )
    + ''

      runHook postInstall
    '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/higan-emu/higan";
    description = "Open-source, cycle-accurate multi-system emulator";
    longDescription = ''
      higan is a multi-system emulator, originally developed by Near, with an
      uncompromising focus on accuracy and code readability.

      It currently emulates the following systems: Famicom, Famicom Disk System,
      Super Famicom, Super Game Boy, Game Boy, Game Boy Color, Game Boy Advance,
      Game Boy Player, SG-1000, SC-3000, Master System, Game Gear, Mega Drive,
      Mega CD, PC Engine, SuperGrafx, MSX, MSX2, ColecoVision, Neo Geo Pocket,
      Neo Geo Pocket Color, WonderSwan, WonderSwan Color, SwanCrystal, Pocket
      Challenge V2.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
# TODO: select between Qt and GTK3
# TODO: call Darwin hackers to deal with respective problems
