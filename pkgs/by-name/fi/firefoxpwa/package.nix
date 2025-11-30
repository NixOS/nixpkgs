{
  extraLibs ? [ ],
  firefoxRuntime ? firefox-unwrapped,

  lib,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  rustPlatform,

  cups,
  ffmpeg,
  firefox-unwrapped,
  libcanberra-gtk3,
  libglvnd,
  libnotify,
  libpulseaudio,
  libva,
  libgbm,
  nixosTests,
  openssl,
  pciutils,
  pipewire,
  pkg-config,
  stdenv,
  udev,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "firefoxpwa";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "filips123";
    repo = "PWAsForFirefox";
    rev = "v${version}";
    hash = "sha256-GKK5PYWSO+rWtuZuHgDQx3V7f8bEX8JHvvFK8sQRli4=";
  };

  sourceRoot = "${src.name}/native";
  buildFeatures = [ "immutable-runtime" ];

  cargoHash = "sha256-aV6Wvv+GzPLsWtdsS3ki82ju1Fh4IgFnIOF4OTEV7uQ=";

  preConfigure = ''
    sed -i 's;version = "0.0.0";version = "${version}";' Cargo.toml
    sed -zi 's;name = "firefoxpwa"\nversion = "0.0.0";name = "firefoxpwa"\nversion = "${version}";' Cargo.lock
    sed -i $'s;DISTRIBUTION_VERSION = \'0.0.0\';DISTRIBUTION_VERSION = \'${version}\';' userchrome/profile/chrome/pwa/chrome.sys.mjs
  '';

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];
  buildInputs = [ openssl ];

  FFPWA_EXECUTABLES = ""; # .desktop entries generated without any store path references
  FFPWA_SYSDATA = "${placeholder "out"}/share/firefoxpwa";
  completions = "target/${stdenv.targetPlatform.config}/release/completions";

  gtk_modules = map (x: x + x.gtkModule) [ libcanberra-gtk3 ];
  libs =
    let
      libs = [
        cups
        ffmpeg
        libglvnd
        libnotify
        libpulseaudio
        libva
        libgbm
        pciutils
        pipewire
        udev
        xorg.libXScrnSaver
      ]
      ++ gtk_modules
      ++ extraLibs;
    in
    lib.makeLibraryPath libs + ":" + lib.makeSearchPathOutput "lib" "lib64" libs;

  postInstall = ''
    # Runtime
    mkdir -p $out/share/firefoxpwa
    cp -Lr ${firefoxRuntime}/lib/${firefoxRuntime.binaryName} $out/share/firefoxpwa/runtime
    chmod -R +w $out/share/firefoxpwa

    if [ "${firefoxRuntime.binaryName}" != "firefox" ]; then
      ln $out/share/firefoxpwa/runtime/${firefoxRuntime.binaryName} $out/share/firefoxpwa/runtime/firefox
    fi

    # UserChrome
    cp -r userchrome $out/share/firefoxpwa

    # Runtime patching
    FFPWA_USERDATA=$out/share/firefoxpwa $out/bin/firefoxpwa runtime patch

    # Manifest
    sed -i "s!/usr/libexec!$out/bin!" manifests/linux.json
    install -Dm644 manifests/linux.json $out/lib/mozilla/native-messaging-hosts/firefoxpwa.json

    installShellCompletion --cmd firefoxpwa \
      --bash $completions/firefoxpwa.bash \
      --fish $completions/firefoxpwa.fish \
      --zsh $completions/_firefoxpwa

    # AppStream Metadata
    install -Dm644 packages/appstream/si.filips.FirefoxPWA.metainfo.xml $out/share/metainfo/si.filips.FirefoxPWA.metainfo.xml
    install -Dm644 packages/appstream/si.filips.FirefoxPWA.svg $out/share/icons/hicolor/scalable/apps/si.filips.FirefoxPWA.svg

    wrapProgram $out/bin/firefoxpwa \
      --prefix FFPWA_SYSDATA : "$out/share/firefoxpwa" \
      --prefix LD_LIBRARY_PATH : "$libs" \
      --suffix-each GTK_PATH : "$gtk_modules"

    wrapProgram $out/bin/firefoxpwa-connector \
      --prefix FFPWA_SYSDATA : "$out/share/firefoxpwa" \
      --prefix LD_LIBRARY_PATH : "$libs" \
      --suffix-each GTK_PATH : "$gtk_modules"
  '';

  passthru.tests.firefoxpwa = nixosTests.firefoxpwa;

  meta = {
    description = "Tool to install, manage and use Progressive Web Apps (PWAs) in Mozilla Firefox (native component)";
    longDescription = ''
      Progressive Web Apps (PWAs) are web apps that use web APIs and features along
      with progressive enhancement strategy to bring a native app-like user experience
      to cross-platform web applications. Although Firefox supports many of Progressive
      Web App APIs, it does not support functionality to install them as a standalone
      system app with an app-like experience.

      This project creates a custom modified Firefox runtime to allow websites to be
      installed as standalone apps and provides a console tool and browser extension
      to install, manage and use them.

      This package contains only the native part of the PWAsForFirefox project. You
      should also install the browser extension if you haven't already. You can download
      it from the [Firefox Add-ons](https://addons.mozilla.org/firefox/addon/pwas-for-firefox/)
      website.

      To install the package on NixOS, you need to add the following options:

      ```
      programs.firefox.nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
      environment.systemPackages = [ pkgs.firefoxpwa ];
      ```

      As it needs to be both in the `PATH` and in the `nativeMessagingHosts` to make it
      possible for the extension to detect and use it.
    '';
    homepage = "https://pwasforfirefox.filips.si/";
    changelog = "https://github.com/filips123/PWAsForFirefox/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      camillemndn
      pasqui23
    ];
    mainProgram = "firefoxpwa";
  };
}
