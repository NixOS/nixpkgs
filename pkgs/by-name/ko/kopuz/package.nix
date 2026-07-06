{
  lib,
  stdenv,
  rustPlatform,
  pkg-config,
  cmake,
  git,
  openssl,
  tailwindcss_4,
  dioxus-cli,
  yt-dlp,
  fetchFromGitHub,
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

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "kopuz";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "Kopuz-org";
    repo = "kopuz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d6wSefvx2KT1EyhLq2pn9MSDtW+AvDj7WVz27MJeTmg=";
  };

  cargoHash = "sha256-fr65eE8wFWtW/PT5ZACGMcNCo/QNo9xf39LVBQMGLVk=";

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
