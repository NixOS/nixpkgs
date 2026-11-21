{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
  dbus,
  desktopToDarwinBundle,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  makeBinaryWrapper,
  makeDesktopItem,
  mpf-check,
  nix-update-script,
  noto-fonts-cjk-sans,
  pkg-config,
  redumper,
  rustPlatform,
  wayland,
  zenity,
  zstd,
  withMpfCheck ? true,
  # zenity adds ~800 MiB to the closure. Used for flashing firmware/confirmation messages
  withZenity ? stdenv.hostPlatform.isLinux,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "redumper-gui";
  version = "1.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Deterous";
    repo = "Redumper-GUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s9HPnfuUYcvyWrccq8Z1MZBw2FketnvTeOi0Ltukjfc=";
  };

  postPatch = ''
    substituteInPlace src/app/fonts.rs \
      --replace-fail '"/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc"' \
        '"${noto-fonts-cjk-sans}/share/fonts/opentype/noto-cjk/NotoSansCJK-VF.otf.ttc"'
  '';

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [ zstd ];

  cargoHash = "sha256-r8AvSP2BRTDJL7QbV1JiFdm9n4lcmqa6JC3rAtuhbOU=";

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  # no tests
  doCheck = false;

  postInstall = ''
    install -Dm444 assets/icon/icon.png $out/share/icons/hicolor/512x512/apps/redumper-gui.png

    mkdir -p $out/libexec/redumper-gui

    mv $out/bin/redumper-gui $out/libexec/redumper-gui/
    ln -s ${lib.getExe redumper} $out/libexec/redumper-gui/redumper

    makeBinaryWrapper $out/libexec/redumper-gui/redumper-gui $out/bin/redumper-gui \
      ${lib.optionalString withMpfCheck "--prefix PATH : ${lib.makeBinPath [ mpf-check ]}"} \
      ${lib.optionalString withZenity "--prefix PATH : ${lib.makeBinPath [ zenity ]}"}
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        dbus
        libGL
        libx11
        libxcursor
        libxi
        libxkbcommon
        wayland
      ]
    } $out/libexec/redumper-gui/redumper-gui
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "redumper-gui";
      categories = [ "Utility" ];
      comment = finalAttrs.meta.description;
      desktopName = "Redumper GUI";
      exec = "redumper-gui";
      icon = "redumper-gui";
      keywords = [
        "redump"
        "cd"
        "dvd"
        "bluray"
        "disc"
        "dump"
      ];
      startupWMClass = "Redumper GUI";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GUI for the redumper optical disc dumper";
    homepage = "https://github.com/Deterous/Redumper-GUI";
    changelog = "https://github.com/Deterous/Redumper-GUI/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "redumper-gui";
    mainDarwinApp = "Redumper GUI.app";
  };
})
