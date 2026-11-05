{
  lib,
  rustPlatform,
  fetchFromGitHub,
  autoPatchelfHook,
  cacert,
  cmake,
  dbus,
  desktop-file-utils,
  fontconfig,
  gnupg,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  makeWrapper,
  nix-update-script,
  pdfium,
  perl,
  pkg-config,
  python3,
  sqlite,
  vulkan-loader,
  wayland,
  xdg-utils,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flectar-mail";
  version = "0.1.0-alpha.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "flectar";
    repo = "mail";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xdjpjFHOKAkLHExbXfssWYz8knRRrAy9rQEErgrN8d4=";
  };

  cargoHash = "sha256-WjEWWxOcGbuWmW+hv4d6DtP6T0Ly6+PooqO48zovU+Y=";

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    desktop-file-utils
    makeWrapper
    perl
    pkg-config
    python3
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    dbus
    fontconfig
    sqlite
  ];

  env.LIBSQLITE3_SYS_USE_PKG_CONFIG = "1";

  # Slint/winit and the renderers load these libraries dynamically.
  runtimeDependencies = [
    (lib.getLib fontconfig)
    libGL
    libx11
    libxcursor
    libxi
    libxkbcommon
    vulkan-loader
    wayland
  ];

  cargoBuildFlags = [ "--bin=flectar-mail" ];
  # Integration tests use the credential backend available only in debug builds.
  checkType = "debug";
  cargoTestFlags = [ "--package=flectar-mail-core" ];

  nativeCheckInputs = [ gnupg ];
  preCheck = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  postInstall = ''
    # The flag only removes AppImage-specific keys from the desktop metadata.
    python3 scripts/stage-linux-metadata.py --flatpak "$TMPDIR/metadata"

    cp -r "$TMPDIR/metadata/usr/share" "$out/share"
    substituteInPlace "$out/share/applications/com.flectar.mail.desktop" \
      --replace-fail 'Exec=flectar-mail' "Exec=$out/bin/flectar-mail"

    install -Dm644 resources/app-icon/flectar-mail-masked-512.png \
      "$out/share/icons/hicolor/512x512/apps/com.flectar.mail.png"

    install -Dm644 resources/app-icon/flectar-mail-masked.svg \
      "$out/share/icons/hicolor/scalable/apps/com.flectar.mail.svg"

    # The PDF worker searches for its library relative to the executable.
    mkdir -p "$out/lib/flectar-mail"
    ln -s ${lib.getLib pdfium}/lib/libpdfium.so "$out/lib/flectar-mail/libpdfium.so"

    wrapProgram "$out/bin/flectar-mail" \
      --set-default MALLOC_ARENA_MAX 1 \
      --set-default MALLOC_TRIM_THRESHOLD_ 65536 \
      --prefix PATH : ${
        lib.makeBinPath [
          gnupg
          xdg-utils
        ]
      }
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    desktop-file-validate "$out/share/applications/com.flectar.mail.desktop"
    python3 scripts/test-pdf-preview.py "$out/bin/flectar-mail"
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native email client with IMAP, SMTP, and JMAP support";
    homepage = "https://github.com/flectar/mail";
    changelog = "https://github.com/flectar/mail/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "flectar-mail";
    maintainers = with lib.maintainers; [ _0x4bs3nt ];
    platforms = [ "x86_64-linux" ];
  };
})
