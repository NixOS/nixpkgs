{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  fetchNpmDeps,
  makeWrapper,
  electron,
  copyDesktopItems,
  makeDesktopItem,

  # Electron runtime deps (Linux-only; Electron uses Cocoa natively on macOS)
  at-spi2-core ? null,
  alsa-lib ? null,
  cups ? null,
  dbus ? null,
  expat ? null,
  gdk-pixbuf ? null,
  glib ? null,
  gtk3 ? null,
  libdrm ? null,
  libglvnd ? null,
  libnotify ? null,
  libpulseaudio ? null,
  libxkbcommon ? null,
  libxshmfence ? null,
  mesa ? null,
  nspr ? null,
  nss ? null,
  pango ? null,
  pipewire ? null,
  udev ? null,
  xdg-utils ? null,
}:

let
  linuxBuildInputs = lib.optionals stdenv.isLinux [
    at-spi2-core
    alsa-lib
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libglvnd
    libnotify
    libpulseaudio
    libxkbcommon
    libxshmfence
    mesa
    nspr
    nss
    pango
    pipewire
    udev
    xdg-utils
  ];
in

buildNpmPackage (finalAttrs: {
  pname = "beyond-all-reason";
  version = "1.2988.0";

  src = fetchFromGitHub {
    owner = "beyond-all-reason";
    repo = "spring-launcher";
    rev = "2c0a6e17b50ab04ea592c53963c571e5ccb071ba";
    hash = "sha256-JfZQaFp81A9o69cJOc6YPop1pLP2sZvfiMjZCFd6+H4=";
  };

  passthru.chobby-src = fetchFromGitHub {
    owner = "beyond-all-reason";
    repo = "BYAR-Chobby";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mqopt/ciIqr4lNHU8RzsZM/Eawt4hs24CmQ5Fszz+tA=";
  };

  # forceGitDeps is needed because register-scheme has install scripts
  # but no lockfile.
  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    forceGitDeps = true;
    hash = "sha256-m3M+fPz+2jDcE5ob4yrZJUCmGTji++YBYMacuV1I/UA=";
  };

  # he only dev dep is electron which we provide :)
  npmInstallFlags = [ "--omit=dev" ];

  # --ignore-scripts: electron's postinstall tries to fetch the binary via HTTPS
  # which is a no
  npmRebuildFlags = [ "--ignore-scripts" ];

  # it's an app so this doesn't apply
  dontNpmBuild = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    electron
  ];

  buildInputs = linuxBuildInputs;

  # Merge BAR-specific config and build assets from BYAR-Chobby into src/,
  # then regenerate package.json
  postPatch = ''
    cp -r ${finalAttrs.passthru.chobby-src}/dist_cfg/* src/
    cp -r ${finalAttrs.passthru.chobby-src}/build .

    node build/make_package_json.js \
      package.json src/config.json \
      beyond-all-reason/spring-launcher ${finalAttrs.version}
  '';

  # The default npmInstallHook runs `npm pack` which doesn't fit the model
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/beyond-all-reason
    cp -r src node_modules package.json $out/lib/beyond-all-reason/
    cp -r bin $out/lib/beyond-all-reason/

    install -Dm644 ${finalAttrs.passthru.chobby-src}/dist_cfg/build/icon.png \
      $out/share/icons/hicolor/256x256/apps/beyond-all-reason.png

    mkdir -p $out/bin
    makeWrapper ${lib.getExe electron} $out/bin/beyond-all-reason \
      --add-flags "$out/lib/beyond-all-reason" \
      --add-flags "--disable-launcher-update" \
      --add-flags "-w \$XDG_DATA_HOME" \
      ${lib.optionalString stdenv.isLinux "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath linuxBuildInputs}"} \
      --set ELECTRON_IS_DEV 0 \
      --set NODE_ENV production

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "beyond-all-reason";
      exec = "beyond-all-reason";
      icon = "beyond-all-reason";
      desktopName = "Beyond All Reason";
      comment = finalAttrs.meta.description;
      categories = [
        "Game"
        "StrategyGame"
      ];
      keywords = [
        "bar"
        "rts"
      ];
      type = "Application";
    })
  ];

  meta = {
    description = "Free real-time strategy game with grand scale and full physical simulation in a sci-fi setting";
    longDescription = ''
      Beyond All Reason (BAR) is a free and open-source real-time strategy
      game built on the Recoil engine. It features massive battles with
      hundreds of units, full ballistic physics, terrain deformation, and
      realistic projectile simulation. Set in a sci-fi universe, BAR is
      inspired by the Total Annihilation and Supreme Commander series and
      supports naval, aerial, and orbital warfare alongside traditional
      ground combat.
    '';
    homepage = "https://www.beyondallreason.info/";
    changelog = "https://github.com/beyond-all-reason/BYAR-Chobby/releases";
    license = lib.licenses.gpl2Plus;
    mainProgram = "beyond-all-reason";
    platforms = lib.platforms.unix;

    # Due to lack of openGL 4.3+ support
    brokenPlatforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      kiyotoko
      philocalyst
    ];
  };
})
