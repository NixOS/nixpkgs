{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  pkg-config,
  aws-lc,
  oniguruma,
  zstd,
  makeWrapper,
  cacert,
  wayland,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  vulkan-loader,
  dbus,
  zenity,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cfait";
  version = "1.2.1";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "trougnouf";
    repo = "cfait";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y5O6+bsfoNC52+YTgptfH8Rv7IORN/m2MwzXh39ofXk=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    aws-lc
    oniguruma
    zstd
  ];
  nativeCheckInputs = [
    cacert
  ];

  cargoHash = "sha256-t+Ppfw+Zx1fXOksm9IXxrvR6Qoy9bhuEVGtcwrTwD00=";
  buildFeatures = [ "gui" ];

  outputs = [
    "out"
    "gui"
  ];

  postInstall = ''
    mkdir -p $gui/bin
    mv $out/bin/cfait-gui $gui/bin/cfait-gui

    install -Dm0644 assets/cfait.desktop -t $gui/share/applications
    install -Dm0644 assets/cfait.svg -t $gui/share/icons/hicolor/scalable/apps
  '';
  # libs are required at runtime only for cfait-gui since they use dlopen
  postFixup = ''
    patchelf $gui/bin/cfait-gui --add-rpath "${
      lib.makeLibraryPath [
        # For winit
        wayland
        libx11
        libxcursor
        libxi
        libxkbcommon
        # For hardware acceleration
        vulkan-loader
        # For notifications (zenity is a fallback)
        dbus
      ]
    }"
    wrapProgram $gui/bin/cfait-gui \
        --prefix PATH ":" ${lib.makeBinPath [ zenity ]}
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(.+)"
    ];
  };

  meta = {
    description = "CalDAV task manager for power users";
    homepage = "https://codeberg.org/trougnouf/cfait";
    changelog = "https://codeberg.org/trougnouf/cfait/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ geoffreyfrogeye ];
    mainProgram = "cfait";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
