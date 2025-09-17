{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
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
  portmasterUI = buildNpmPackage rec {
    pname = "portmaster-ui";
    version = "2.0.25";
    src = fetchFromGitHub {
      owner = "safing";
      repo = "portmaster";
      tag = "v${version}";
      hash = "sha256-WNiL8csCpTqXWUbGLR4I7i+uVRVbxBBa63EcX99Rjuw=";
    };

    sourceRoot = "${src.name}/desktop/angular";
    npmDepsHash = "sha256-RLxcdedAw37gUhpZq+LySa8OFa2ExRUsQtnb0oxEP1Y=";

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
  };

  portmasterDesktop = rustPlatform.buildRustPackage rec {
    pname = "portmaster-desktop";
    version = "2.0.25";

    src = fetchFromGitHub {
      owner = "safing";
      repo = "portmaster";
      tag = "v${version}";
      hash = "sha256-WNiL8csCpTqXWUbGLR4I7i+uVRVbxBBa63EcX99Rjuw=";
    };

    sourceRoot = "${src.name}/desktop/tauri/src-tauri";

    cargoHash = "sha256-b5uA+4ZnRHvhYq/izLyYqlKABx8EcPjm3Eyvn7muRLk=";

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

    # Build the Angular frontend first and make it available to Tauri
    preBuild = ''
      # Create the angular directory structure within the current source directory
      # Since we can't go up directories in Nix sandbox, we create it locally
      mkdir -p angular/dist/tauri-builtin

      # Copy the built Angular app to where Tauri expects it
      cp -r ${portmasterUI}/* angular/dist/tauri-builtin/

      echo "Original Tauri config frontendDist:"
      grep -A1 -B1 frontendDist tauri.conf.json5 || echo "frontendDist not found"

      # Update the frontendDist path to point to our local directory
      sed -i 's|"../../angular/dist/tauri-builtin"|"../angular/dist/tauri-builtin"|g' tauri.conf.json5 || {
        echo "Failed to update tauri.conf.json5, trying alternative path patterns..."
        sed -i 's|../../angular/dist/tauri-builtin|../angular/dist/tauri-builtin|g' tauri.conf.json5
      }

      echo "Updated Tauri config frontendDist:"
      grep -A1 -B1 frontendDist tauri.conf.json5 || echo "frontendDist not found"

      # Set up environment for Tauri build
      export TAURI_PRIVATE_KEY=""
      export TAURI_KEY_PASSWORD=""
    '';

    doCheck = false;
  };
in

buildGoModule rec {
  pname = "portmaster";
  version = "2.0.25";

  src = fetchFromGitHub {
    owner = "safing";
    repo = "portmaster";
    tag = "v${version}";
    hash = "sha256-WNiL8csCpTqXWUbGLR4I7i+uVRVbxBBa63EcX99Rjuw=";
  };

  vendorHash = "sha256-63Cj6gGcdE9Y93zydlO6+PXnkSvNfgb+64mZRHVAxF0=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
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
    "-X github.com/safing/portmaster/base/info.version=${version}"
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

        # Install the UI files in the correct structure for the web server
        mkdir -p $out/usr/lib/portmaster/ui/modules/portmaster
        cp -r ${portmasterUI}/* $out/usr/lib/portmaster/ui/modules/portmaster/

        # Create portmaster.zip with the Angular UI for compatibility
        echo "Creating portmaster.zip with Angular UI..."
        cd ${portmasterUI}
        zip -r $out/usr/lib/portmaster/portmaster.zip .
        cd -

        # Create assets.zip with static assets
        echo "Creating assets.zip..."
        (cd assets && zip -r $out/usr/lib/portmaster/assets.zip .)

        # Install icon
        install -Dm644 assets/data/favicons/favicon-96x96.png $out/share/icons/hicolor/96x96/apps/portmaster.png

        # Create symlinks in bin
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
    maintainers = with lib.maintainers; [ WitteShadovv ];
    mainProgram = "portmaster";
  };
}
