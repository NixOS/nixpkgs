{
  lib,
  buildGoModule,
  buildNpmPackage,
  buildPackages,
  cargo-tauri,
  copyDesktopItems,
  fetchFromGitHub,
  glib-networking,
  iproute2,
  iptables,
  libayatana-appindicator,
  makeBinaryWrapper,
  makeDesktopItem,
  nftables,
  nix-update-script,
  nixosTests,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  unzip,
  webkitgtk_4_1,
  wrapGAppsHook4,
  zip,
}:

let
  version = "2.2.1";

  nodejsPython = buildPackages.nodejs.python.withPackages (ps: [ ps.setuptools ]);

  src = fetchFromGitHub {
    owner = "safing";
    repo = "portmaster";
    tag = "v${version}";
    hash = "sha256-MkVVRPI0yoQ9dl2vyluSz+eNgErfcMveLmeaReJuYIM=";
  };

  portmasterUI = buildNpmPackage {
    pname = "portmaster-ui";
    inherit version src;

    # The main UI is served by portmaster-core; the smaller bootstrap UI is
    # embedded into the Tauri desktop executable.
    outputs = [
      "out"
      "tauri"
    ];

    sourceRoot = "${src.name}/desktop/angular";
    npmDepsHash = "sha256-MVlOjD/rKtR+bcCz51mDhZo65jyqTAa1Al+sK/1hJgw=";

    nativeBuildInputs = [ nodejsPython ];

    # node-gyp 9 still imports distutils. Point it at the setuptools-backed
    # Python environment explicitly because buildNpmPackage also adds Node's
    # bare Python interpreter to PATH.
    env.PYTHON = lib.getExe nodejsPython;

    postPatch = ''
      # Assets are provided by the separate assets.zip module.
      rm assets
    '';

    postBuild = ''
      NODE_ENV=production npm run ng -- build --configuration production tauri-builtin
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out $tauri
      mv dist/tauri-builtin/* $tauri/
      rmdir dist/tauri-builtin
      cp -r dist/* $out/

      runHook postInstall
    '';

    dontFixup = true;
  };

  portmasterDesktop = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "portmaster-desktop";
    inherit version src;

    cargoHash = "sha256-QK/L3vUD+MZjFVLgwWm+kZIgXY9ol0y9EIP7aSD45sU=";
    cargoRoot = "desktop/tauri/src-tauri";
    buildAndTestSubdir = finalAttrs.cargoRoot;

    postPatch = ''
      # libappindicator-sys loads AppIndicator with dlopen, so the dependency
      # cannot be discovered and patched automatically.
      substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
        --replace-fail \
          "libayatana-appindicator3.so.1" \
          "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    '';

    nativeBuildInputs = [
      cargo-tauri.hook
      pkg-config
      wrapGAppsHook4
    ];

    buildInputs = [
      glib-networking
      libayatana-appindicator
      openssl
      webkitgtk_4_1
    ];

    preBuild = ''
      mkdir -p desktop/angular/dist
      ln -s ${portmasterUI.tauri} desktop/angular/dist/tauri-builtin
    '';

    # The final package creates the distribution archives itself. Use Tauri to
    # build the desktop executable without reproducing upstream's deb bundle.
    tauriBuildFlags = [ "--no-bundle" ];

    installPhase = ''
      runHook preInstall

      install -Dm755 \
        target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/portmaster \
        $out/bin/portmaster

      runHook postInstall
    '';

    # The XDG tests initialize GTK and require a display server.
    doCheck = false;

    # The final package wraps the binary after placing it in Portmaster's
    # trusted binary directory.
    dontWrapGApps = true;
  });
in
buildGoModule (finalAttrs: {
  pname = "portmaster";
  inherit version src;

  __structuredAttrs = true;

  patches = [
    # Portmaster documents --bin-dir as read-only capable. Accept Nix's 0555
    # store directory instead of trying to change its permissions.
    ./allow-read-only-bin-dir.patch
    # Nix owns the program files. Intelligence updates remain enabled and are
    # written below the service's state directory.
    ./disable-software-updates.patch
  ];

  vendorHash = "sha256-22sIbmpbgYtOwrnxcrKfksgbyqaFRH5DZ/UNXr8723I=";

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
    wrapGAppsHook4
    zip
  ];

  buildInputs = [
    glib-networking
    libayatana-appindicator
    openssl
    webkitgtk_4_1
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "portmaster";
      desktopName = "Portmaster";
      genericName = "Application Firewall";
      exec = "portmaster";
      icon = "portmaster";
      comment = "Free and open-source application firewall";
      categories = [ "System" ];
      startupWMClass = "portmaster";
      terminal = false;
    })
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/safing/portmaster/base/info.version=${version}"
    "-X github.com/safing/portmaster/base/info.buildSource=nixpkgs"
  ];

  subPackages = [ "cmds/portmaster-core" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/portmaster

    install -m755 $GOPATH/bin/portmaster-core $out/lib/portmaster/
    install -m755 ${portmasterDesktop}/bin/portmaster $out/lib/portmaster/

    pushd ${portmasterUI}
    zip -q -r -9 -X $out/lib/portmaster/portmaster.zip .
    popd

    pushd assets/data
    zip -q -r -9 -X $out/lib/portmaster/assets.zip .
    popd

    for size in 128 256 512; do
      install -Dm644 \
        "assets/data/icons/pm_dark_''${size}.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/portmaster.png"
    done
    install -Dm644 assets/data/icons/pm_light_contrast.svg \
      "$out/share/icons/hicolor/scalable/apps/portmaster.svg"

    install -Dm644 packaging/linux/portmaster-autostart.desktop \
      "$out/etc/xdg/autostart/portmaster.desktop"
    substituteInPlace "$out/etc/xdg/autostart/portmaster.desktop" \
      --replace-fail \
        '/usr/bin/portmaster --with-prompts --with-notifications --background' \
        "$out/bin/portmaster --background"

    runHook postInstall
  '';

  preFixup = ''
    substituteInPlace "$out/share/applications/portmaster.desktop" \
      --replace-fail 'Exec=portmaster' "Exec=$out/bin/portmaster"

    wrapGApp "$out/lib/portmaster/portmaster"
    ln -s ../lib/portmaster/portmaster "$out/bin/portmaster"

    makeWrapper "$out/lib/portmaster/portmaster-core" "$out/bin/portmaster-core" \
      --prefix PATH : ${
        lib.makeBinPath [
          iptables
          iproute2
          nftables
        ]
      }
  '';

  # The desktop executable is wrapped explicitly in its non-standard location.
  dontWrapGApps = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ unzip ];
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/portmaster-core version | grep -F 'Portmaster ${version}'
    ${lib.getExe unzip} -tq $out/lib/portmaster/portmaster.zip
    ${lib.getExe unzip} -tq $out/lib/portmaster/assets.zip
    ${lib.getExe unzip} -Z1 $out/lib/portmaster/portmaster.zip | grep -Fx index.html
    ${lib.getExe unzip} -Z1 $out/lib/portmaster/assets.zip | grep -q '^img/flags/'
    ! ${lib.getExe unzip} -Z1 $out/lib/portmaster/assets.zip | grep -q '^data/'
    test -x $out/lib/portmaster/.portmaster-wrapped
    grep -aF \
      '${libayatana-appindicator}/lib/libayatana-appindicator3.so.1' \
      $out/lib/portmaster/.portmaster-wrapped

    runHook postInstallCheck
  '';

  passthru = {
    inherit portmasterDesktop portmasterUI;

    tests = { inherit (nixosTests) portmaster; };

    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "portmasterUI"
        "--subpackage"
        "portmasterDesktop"
      ];
    };
  };

  meta = {
    description = "Free and open-source application firewall";
    homepage = "https://safing.io/portmaster/";
    changelog = "https://github.com/safing/portmaster/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      WitteShadovv
      nyabinary
    ];
    mainProgram = "portmaster";
  };
})
