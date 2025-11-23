{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  makeBinaryWrapper,
  nodejs,
  glib,
  gtk3,
  cairo,
  pango,
  gdk-pixbuf,
  atk,
  webkitgtk_4_1,
  libsoup_3,
  openssl,
  curl,
  systemdLibs,
  iptables,
  iproute2,
  xorg,
  alsa-lib,
  nss,
  nspr,
  at-spi2-atk,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  zlib,
  libayatana-appindicator,
  coreutils,
  zip,
  rustPlatform,
  cargo-tauri,
  wrapGAppsHook4,
  librsvg,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
}:

let
  portmasterUI = buildNpmPackage (finalAttrs: {
    pname = "portmaster-ui";
    version = "2.0.27";
    src = fetchFromGitHub {
      owner = "safing";
      repo = "portmaster";
      tag = "v${finalAttrs.version}";
      hash = "sha256-4NqRGUNP9Ql2OvzyMgIeXU5do2EQZk6ytF5RvGt5pIc=";
    };

    sourceRoot = "${finalAttrs.src.name}/desktop/angular";
    npmDepsHash = "sha256-/Y5P8WNfsTsFEkwGrc1/dnXEpsSOy48UgiNLAA2irf4=";

    buildPhase = ''
      runHook preBuild
      npm run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist/* $out/
      runHook postInstall
    '';

    dontFixup = true;
  });

  portmasterDesktop = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "portmaster-desktop";
    version = "2.0.27";

    src = fetchFromGitHub {
      owner = "safing";
      repo = "portmaster";
      tag = "v${finalAttrs.version}";
      hash = "sha256-4NqRGUNP9Ql2OvzyMgIeXU5do2EQZk6ytF5RvGt5pIc=";
    };

    sourceRoot = "${finalAttrs.src.name}/desktop/tauri/src-tauri";

    cargoHash = "sha256-C90M/rLc0D5UUJeQTi7XEW3ckPJUlcvDgAXaekamKJo=";

    nativeBuildInputs = [
      pkg-config
      wrapGAppsHook4
    ];

    buildInputs = [
      glib
      gtk3
      cairo
      pango
      gdk-pixbuf
      atk
      webkitgtk_4_1
      libsoup_3
      openssl
      librsvg
    ];

    preBuild = ''
      mkdir -p angular/dist/tauri-builtin
      cp -r ${portmasterUI}/* angular/dist/tauri-builtin/
      grep -A1 -B1 frontendDist tauri.conf.json5 || echo "frontendDist not found"

      sed -i 's|"../../angular/dist/tauri-builtin"|"../angular/dist/tauri-builtin"|g' tauri.conf.json5 || {
        echo "Failed to update tauri.conf.json5, trying alternative path patterns..."
        sed -i 's|../../angular/dist/tauri-builtin|../angular/dist/tauri-builtin|g' tauri.conf.json5
      }

      grep -A1 -B1 frontendDist tauri.conf.json5 || echo "frontendDist not found"

      export TAURI_PRIVATE_KEY=""
      export TAURI_KEY_PASSWORD=""
    '';

    doCheck = false;
  });
in

buildGoModule (finalAttrs: {
  pname = "portmaster";
  version = "2.0.27";

  src = fetchFromGitHub {
    owner = "safing";
    repo = "portmaster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4NqRGUNP9Ql2OvzyMgIeXU5do2EQZk6ytF5RvGt5pIc=";
  };

  vendorHash = "sha256-uPo1tRUfl4kY1sMlLoc0y6ctygRN5MJPrR5TTgERk6U=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
    nodejs
    zip
    copyDesktopItems
    autoPatchelfHook
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "portmaster";
      exec = "portmaster --data /var/lib/portmaster --log-dir /var/lib/portmaster/logs";
      icon = "portmaster";
      desktopName = "Portmaster";
      comment = "Free and open-source application firewall";
      categories = [
        "Network"
        "Security"
      ];
      startupNotify = false;
      terminal = false;
    })
  ];

  buildInputs = [
    glib
    gtk3
    cairo
    pango
    gdk-pixbuf
    atk
    webkitgtk_4_1
    libsoup_3
    openssl
    curl
    systemdLibs
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    xorg.libXrandr
    xorg.libXScrnSaver
    xorg.libxcb
    alsa-lib
    nss
    nspr
    at-spi2-atk
    cups
    dbus
    expat
    fontconfig
    freetype
    zlib
    libayatana-appindicator
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/safing/portmaster/base/info.version=${finalAttrs.version}"
    "-X github.com/safing/portmaster/base/info.commit=nixpkgs"
  ];

  subPackages = [
    "cmds/portmaster-core"
  ];

  doCheck = false;

  installPhase = ''
    runHook preInstall

        mkdir -p $out/bin $out/usr/lib/portmaster \
          $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256,512x512}/apps

        install -m755 $GOPATH/bin/portmaster-core $out/usr/lib/portmaster/
        install -m755 ${portmasterDesktop}/bin/* $out/usr/lib/portmaster/portmaster

        mkdir -p $out/usr/lib/portmaster/ui/modules/portmaster
        cp -r ${portmasterUI}/* $out/usr/lib/portmaster/ui/modules/portmaster/

        echo "Creating portmaster.zip with Angular UI..."
        cd ${portmasterUI}
        zip -r $out/usr/lib/portmaster/portmaster.zip .
        cd -

        echo "Creating assets.zip..."
        (cd assets && zip -r $out/usr/lib/portmaster/assets.zip .)

        install -Dm644 assets/data/favicons/favicon-96x96.png $out/share/icons/hicolor/96x96/apps/portmaster.png

        ln -s $out/usr/lib/portmaster/portmaster-core $out/bin/portmaster-core
        ln -s $out/usr/lib/portmaster/portmaster $out/bin/portmaster

        runHook postInstall
  '';

  postFixup = ''
    for binary in $out/usr/lib/portmaster/portmaster*; do
      if [ -x "$binary" ]; then
        echo "Wrapping binary: $binary"
        wrapProgram "$binary" \
          --prefix PATH : ${
            lib.makeBinPath [
              iptables
              iproute2
            ]
          } \
          --prefix LD_LIBRARY_PATH : ${
            lib.makeLibraryPath [
              libayatana-appindicator
            ]
          } \
          --set-default GDK_BACKEND "wayland,x11" \
          --set WEBKIT_DISABLE_COMPOSITING_MODE "1" \
          --set WEBKIT_DISABLE_DMABUF_RENDERER "1" \
          --set LIBGL_ALWAYS_SOFTWARE "1"
      fi
    done
  '';

  meta = {
    description = "Free and open-source application firewall";
    homepage = "https://safing.io/portmaster/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      WitteShadovv
      nyabinary
    ];
    mainProgram = "portmaster";
  };
})
