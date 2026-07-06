{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  cmake,
  pkg-config,
  protobuf,
  fontconfig,
  libgit2,
  openssl,
  sqlite,
  zlib,
  zstd,
  libxkbcommon,
  wayland,
  libxcb,
  stdenv,
  libGL,
  vulkan-loader,
  envsubst,
  nix-update-script,
  cargo-about,
  versionCheckHook,
  cargo-bundle,
  git,
  testers,
  writableTmpDirAsHomeHook,

  buildRemoteServer ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gram";
  version = "2.1.2";

  outputs = [
    "out"
  ]
  ++ lib.optionals buildRemoteServer [
    "remote_server"
  ];

  src = fetchFromCodeberg {
    owner = "GramEditor";
    repo = "gram";
    tag = finalAttrs.version;
    hash = "sha256-7FzAvC/JMMIFcuTGkL2Ju644UAIsneOMhiDUFnQske4=";
  };

  postPatch = ''
    # The generate-licenses script wants a specific version of cargo-about eventhough
    # newer versions work just as well.
    substituteInPlace script/generate-licenses \
      --replace-fail '$CARGO_ABOUT_VERSION' '${cargo-about.version}'
  '';

  cargoHash = "sha256-feESY8ALSG3xa906HBc4pOKGerQ1jF7VUxzvUcsZbrY=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    cargo-about
    cmake
    pkg-config
    protobuf
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cargo-bundle
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    libgit2
    openssl
    sqlite
    zlib
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    fontconfig
    libxcb
    libxkbcommon
  ];

  cargoBuildFlags = [
    "--package=gram"
    "--package=cli"
  ]
  ++ lib.optionals buildRemoteServer [ "--package=remote_server" ];

  # Required on darwin because we don't have access to the proprietary Metal shader compiler.
  buildFeatures = lib.optionals stdenv.hostPlatform.isDarwin [ "gpui/runtime_shaders" ];

  env = {
    ALLOW_MISSING_LICENSES = true;
    OPENSSL_NO_VENDOR = true;
    LIBGIT2_NO_VENDOR = true;
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
    RELEASE_VERSION = finalAttrs.version;
  };

  preBuild = ''
    bash script/generate-licenses
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  useNextest = true;

  remoteServerExecutableName = "gram-remote-server-stable-${finalAttrs.version}";
  installPhase = ''
    runHook preInstall

    release_target="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # cargo-bundle expects the binary in target/release
    mv $release_target/gram target/release/gram

    pushd crates/gram
    # Note that this is GNU sed, while Gram's bundle-mac uses BSD sed
    sed -i "s/package.metadata.bundle-stable/package.metadata.bundle/" Cargo.toml
    export CARGO_BUNDLE_SKIP_BUILD=true
    app_path=$(cargo bundle --release | xargs)
    popd

    mkdir -p $out/Applications $out/bin
    # Gram expects git next to its own binary
    ln -s ${lib.getExe git} $app_path/Contents/MacOS/git
    mv $release_target/cli $app_path/Contents/MacOS/cli
    mv $app_path $out/Applications/

    # Physical location of the CLI must be inside the app bundle as this is used
    # to determine which app to start
    ln -s $out/Applications/Gram.app/Contents/MacOS/cli $out/bin/gram
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm755 $release_target/gram $out/libexec/gram-editor
    install -Dm755 $release_target/cli $out/bin/gram

    install -Dm644 $src/crates/gram/resources/app.liten.Gram.svg $out/share/icons/hicolor/scalable/apps/app.liten.Gram.svg
    install -Dm644 $src/crates/gram/resources/app.liten.Gram-symbolic.svg $out/share/icons/hicolor/scalable/apps/app.liten.Gram-symbolic.svg

    # See https://codeberg.org/GramEditor/gram/src/branch/main/crates/gram/resources/gram.desktop.in
    (
      export DO_STARTUP_NOTIFY="true"
      export APP_CLI="gram"
      export APP_ICON="app.liten.Gram"
      export APP_NAME="Gram"
      export APP_ARGS="%U"
      mkdir -p "$out/share/applications"
      ${lib.getExe envsubst} < "crates/gram/resources/gram.desktop.in" > "$out/share/applications/app.liten.Gram.desktop"
    )
  ''
  + lib.optionalString buildRemoteServer ''
    install -Dm755 $release_target/remote_server $remote_server/bin/${finalAttrs.remoteServerExecutableName}
  ''
  + ''
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/libexec/gram-editor --add-rpath ${
      lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
      ]
    }
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      remoteServerVersion = testers.testVersion {
        package = finalAttrs.finalPackage.remote_server;
        command = "${finalAttrs.remoteServerExecutableName} version";
      };
    };
  };

  meta = {
    description = "Powerful and modern source code editor";
    homepage = "https://gram-editor.com";
    changelog = "https://codeberg.org/GramEditor/gram/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      niklaskorz
    ];
    mainProgram = "gram";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
