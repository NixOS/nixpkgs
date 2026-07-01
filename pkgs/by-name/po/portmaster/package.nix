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
  libx11,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrender,
  libxtst,
  libxrandr,
  libxscrnsaver,
  libxcb,
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
  ripgrep,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
}:

let
  version = "2.1.19";
  src = fetchFromGitHub {
    owner = "safing";
    repo = "portmaster";
    tag = "v${version}";
    hash = "sha256-c9c8Tmj/iddPVwCS11k0Mf3GwMWG6FFiGM0ayEpAl9Y=";
  };

  uiAssetBasePath = "/ui/modules/portmaster/assets/";

  portmasterUI = buildNpmPackage {
    pname = "portmaster-ui";
    inherit version src;

    sourceRoot = "${src.name}/desktop/angular";
    npmDepsHash = "sha256-g7hu6IQCPYRuJaeebydSlIx1hDZGNU9v5ZjecWgB7as=";

    nativeBuildInputs = [ ripgrep ];

    buildPhase = ''
      runHook preBuild
      npm run build

      for file in $(${ripgrep}/bin/rg -l --fixed-strings '/assets/' dist); do
        substituteInPlace "$file" --replace-fail '/assets/' '${uiAssetBasePath}'
      done

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist/* $out/
      runHook postInstall
    '';

    dontFixup = true;
  };

  portmasterDesktop = rustPlatform.buildRustPackage {
    pname = "portmaster-desktop";
    inherit version src;

    sourceRoot = "${src.name}/desktop/tauri/src-tauri";
    cargoHash = "sha256-irAfRgtw7JNJZLCIJdCwfQZ0LnvxTY/IOH4hMkortKY=";

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
  };
in
buildGoModule {
  pname = "portmaster";
  inherit version src;

  __structuredAttrs = true;

  vendorHash = "sha256-22sIbmpbgYtOwrnxcrKfksgbyqaFRH5DZ/UNXr8723I=";

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
    libx11
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrender
    libxtst
    libxrandr
    libxscrnsaver
    libxcb
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
    "-X github.com/safing/portmaster/base/info.version=${version}"
    "-X github.com/safing/portmaster/base/info.commit=nixpkgs"
  ];

  subPackages = [ "cmds/portmaster-core" ];

  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/portmaster \
      $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256,512x512}/apps

    install -m755 $GOPATH/bin/portmaster-core $out/lib/portmaster/
    install -m755 ${portmasterDesktop}/bin/portmaster $out/lib/portmaster/portmaster

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
    wrapProgram "$out/lib/portmaster/portmaster-core" \
      --prefix PATH : ${
        lib.makeBinPath [
          iptables
          iproute2
        ]
      }

    wrapProgram "$out/lib/portmaster/portmaster" \
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
}
