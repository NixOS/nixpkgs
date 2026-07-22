{
  lib,
  stdenv,
  rustPlatform,
  pkg-config,
  cmake,
  git,
  openssl,
  cacert,
  tailwindcss_4,
  dioxus-cli,
  yt-dlp,
  fetchFromGitHub,
  fetchurl,
  libopus,
  # Linux only
  wrapGAppsHook3,
  webkitgtk_4_1,
  gtk3,
  libsoup_3,
  glib-networking,
  alsa-lib,
  xdotool,
  wayland,
  dbus,
  libayatana-appindicator,
}:

let
  rustyV8Version = "130.0.7";
  rustyV8Target = stdenv.hostPlatform.rust.rustcTarget;
  rustyV8Hashes = {
    "aarch64-apple-darwin" = "sha256-9tvQD08OdW6GoNnx/3vgS27D9Aj9YdQdNJ9SgNvwAOo=";
    "aarch64-unknown-linux-gnu" = "sha256-vu/ns1q+53FZ98tVCWZmsHYwwRBH1fOnTdBlhjcpkVo=";
    "x86_64-unknown-linux-gnu" = "sha256-pkdsuU6bAkcIHEZUJOt5PXdzK424CEgTLXjLtQ80t10=";
  };
  librustyV8 = fetchurl {
    url = "https://github.com/denoland/rusty_v8/releases/download/v${rustyV8Version}/librusty_v8_release_${rustyV8Target}.a.gz";
    hash =
      rustyV8Hashes.${rustyV8Target}
        or (throw "no prebuilt librusty_v8 hash for target ${rustyV8Target}");
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "kopuz";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "Kopuz-org";
    repo = "kopuz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Un2U9pfUfEHyx7x2zx7hRrAkqd/PbODCOZyb4EcC9o=";
  };

  cargoHash = "sha256-so8Q2Xx5XRQBB7RvD3muciPIUryW75AN5L98EnXJLMY=";

  env = {
    RUSTY_V8_ARCHIVE = librustyV8;
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    tailwindcss_4
    dioxus-cli
    git
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
  ];

  buildInputs = [
    libopus
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
    gtk3
    libsoup_3
    glib-networking
    alsa-lib
    openssl
    xdotool
    wayland
    dbus
    libayatana-appindicator
  ];

  buildPhase = ''
    runHook preBuild

    tailwindcss -i tailwind.css -o crates/kopuz/assets/tailwind.css --minify

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
            mkdir -p "$TMPDIR/fake-bin"
            cat > "$TMPDIR/fake-bin/codesign" << 'CODESIGN_EOF'
      #!/bin/sh
      exec true
      CODESIGN_EOF
            chmod +x "$TMPDIR/fake-bin/codesign"
            export PATH="$TMPDIR/fake-bin:$PATH"
    ''}

    dx build --release --platform desktop -p kopuz --offline --frozen

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    ${
      if stdenv.hostPlatform.isLinux then
        ''
          cp -r target/dx/kopuz/release/linux/app/* $out/bin/

          install -Dm644 data/com.temidaradev.kopuz.desktop \
            $out/share/applications/com.temidaradev.kopuz.desktop
          substituteInPlace $out/share/applications/com.temidaradev.kopuz.desktop \
            --replace-fail "Exec=kopuz" "Exec=$out/bin/kopuz"

          install -Dm644 data/com.temidaradev.kopuz.metainfo.xml \
            $out/share/metainfo/com.temidaradev.kopuz.metainfo.xml

          install -Dm644 crates/kopuz/assets/logo.png \
            $out/share/icons/hicolor/256x256/apps/com.temidaradev.kopuz.png
        ''
      else
        ''
          # Dioxus outputs the bundle at macos/Kopuz.app (capitalised, no app/ subdir)
          cp -r target/dx/kopuz/release/macos/Kopuz.app $out/bin/kopuz.app
          # Symlink whatever binary dioxus placed in MacOS/ (name may differ in case)
          macBin=$(find $out/bin/kopuz.app/Contents/MacOS -maxdepth 1 -type f | head -1)
          ln -s "$macBin" $out/bin/kopuz
        ''
    }

    runHook postInstall
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --chdir $out/bin
      --prefix PATH : ${lib.makeBinPath [ yt-dlp ]}
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libayatana-appindicator ]}
    )
  '';

  meta = {
    description = "Fast, modern music player with Jellyfin and local library support";
    homepage = "https://github.com/Kopuz-org/kopuz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      temidaradev
      NotAShelf
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "kopuz";
  };
})
