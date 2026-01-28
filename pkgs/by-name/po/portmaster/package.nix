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
  zip,
  rustPlatform,
  wrapGAppsHook4,
  librsvg,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
}:

let
  portmasterUI = buildNpmPackage (finalAttrs: {
    pname = "portmaster-ui";
    version = "2.1.7";
    src = fetchFromGitHub {
      owner = "safing";
      repo = "portmaster";
      tag = "v${finalAttrs.version}";
      hash = "sha256-DUDfeSdIH3e5yx1KKW6h6+HKKQ3WNllsdairjAkTdJs=";
    };

    sourceRoot = "${finalAttrs.src.name}/desktop/angular";
    npmDepsHash = "sha256-yoEGoeXcJIGjjD+r+dQoAdeY7mX3VWOt3LAAO+B0bhA=";

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
    version = "2.1.7";

    src = fetchFromGitHub {
      owner = "safing";
      repo = "portmaster";
      tag = "v${finalAttrs.version}";
      hash = "sha256-DUDfeSdIH3e5yx1KKW6h6+HKKQ3WNllsdairjAkTdJs=";
    };

    sourceRoot = "${finalAttrs.src.name}/desktop/tauri/src-tauri";

    cargoHash = "sha256-q3kgXM06yEuEf+VyywpCHmUGt43RRdSFzTaVlU/jfjc=";

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
      ln -s ${portmasterUI}/* angular/dist/tauri-builtin/
      substituteInPlace tauri.conf.json5 \
        --replace-fail '"../../angular/dist/tauri-builtin"' '"../angular/dist/tauri-builtin"'
    '';

    env = {
      TAURI_KEY_PASSWORD = "";
      TAURI_PRIVATE_KEY = "";
    };

    doCheck = false;
  });

in
buildGoModule (finalAttrs: {
  pname = "portmaster";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "safing";
    repo = "portmaster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DUDfeSdIH3e5yx1KKW6h6+HKKQ3WNllsdairjAkTdJs=";
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

  subPackages = [ "cmds/portmaster-core" ];

  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/portmaster \
      $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256,512x512}/apps

    install -m755 $GOPATH/bin/portmaster-core $out/lib/portmaster/
    install -m755 ${portmasterDesktop}/bin/* $out/lib/portmaster/portmaster

    mkdir -p $out/lib/portmaster/ui/modules/portmaster
    cp -r ${portmasterUI}/* $out/lib/portmaster/ui/modules/portmaster/

    pushd ${portmasterUI}
    zip -r $out/lib/portmaster/portmaster.zip .
    popd

    pushd assets
    zip -r $out/lib/portmaster/assets.zip .
    popd

    install -Dm644 assets/data/favicons/favicon-96x96.png $out/share/icons/hicolor/96x96/apps/portmaster.png

    ln -s $out/lib/portmaster/portmaster-core $out/bin/portmaster-core
    ln -s $out/lib/portmaster/portmaster $out/bin/portmaster

    runHook postInstall
  '';

  postFixup = ''
    for binary in $out/lib/portmaster/portmaster*; do
      if [ -x "$binary" ]; then
        wrapProgram "$binary" \
          --prefix PATH : ${
            lib.makeBinPath [
              iptables
              iproute2
            ]
          } \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libayatana-appindicator ]} \
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
