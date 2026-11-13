{
  lib,
  fetchFromGitHub,
  _7zz,
  bash,
  bubblewrap,
  cabextract,
  curl,
  ffmpeg-headless,
  fuse-overlayfs,
  glib,
  libarchive,
  me3,
  meson,
  ninja,
  nix-update-script,
  python3Packages,
  qt6,
  rustPlatform,
  sqlite,
  umu-launcher,
  util-linux,
  versionCheckHook,
  vgmstream,
  winetricks,
  xdg-utils,
  withLoot ? true,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "amethyst-mod-manager";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "ChrisDKN";
    repo = "Amethyst-Mod-Manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uF7B/lJIy96d9yKMLP/80FR5LgyX34MnxarMlSvx2Y0=";
  };

  patches = [
    ./disable-update-notifications.diff
  ];

  postPatch = ''
    patchShebangs src/version.py

    substituteInPlace amethyst-mod-manager amethyst-mod-manager-cli \
        --replace-fail "exec python3" "exec ${python3Packages.python.interpreter}"

    # amethyst_filegraph
    install "$amethyst_filegraph"/lib/libamethyst_filegraph.so src/amethyst_filegraph.abi3.so

    # get_tools_dir
    substituteInPlace src/Utils/wine/protontricks.py \
        --replace-fail '_get_tools_dir() / "winetricks"' 'Path("${lib.getExe winetricks}")' \
        --replace-fail '_get_tools_dir() / "cabextract"' 'Path("${lib.getExe cabextract}")'

    # --nxm %u
    substituteInPlace src/Nexus/nxm_handler.py \
        --replace-fail \
            "f'{cls._quote_if_needed(exe)} {cls._quote_if_needed(script)} --nxm %u'" \
            "'amethyst-mod-manager --nxm %u'"
  '';

  nativeBuildInputs = [
    meson
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  # no upstream tests; only run the version check
  nativeCheckInputs = [ versionCheckHook ];

  postFixup = ''
    makeWrapperArgs+=(
        --prefix PYTHONPATH : "$program_PYTHONPATH"
        --suffix PATH : ${lib.escapeShellArg (lib.makeBinPath finalAttrs.runtimeInputs)}
    )
    wrapQtApp $out/bin/amethyst-mod-manager "''${makeWrapperArgs[@]}"
    wrapProgram $out/bin/amethyst-mod-manager-cli "''${makeWrapperArgs[@]}"
    rm -r $out/share/metainfo
  '';

  amethyst_filegraph = rustPlatform.buildRustPackage {
    inherit (finalAttrs) src;
    pname = "amethyst-filegraph";
    version = "0.1.0";
    cargoHash = "sha256-PGyUuwwU44/0lHfHEipgi5TxGyXbdDPar/mDqHLFsgM=";
    sourceRoot = "${finalAttrs.src.name}/native/amethyst_filegraph";
    buildInputs = [
      sqlite
    ];
  };

  dependencies =
    with python3Packages;
    [
      # requirements-vendor.txt
      py7zr
      rarfile
      pillow
      lz4
      zstandard
      requests
      pyyaml
      keyring
      jeepney
      msgpack
      bsdiff4
      cryptography
      secretstorage
      certifi
      xxhash
      # base
      pyside6
    ]
    ++ lib.optional withLoot libloot;

  dontWrapQtApps = true;

  pyproject = false;

  pythonImportsCheck = [
    "cli"
    "run_qt"
  ];

  runtimeInputs = [
    _7zz
    bash
    bubblewrap # bwrap
    curl
    ffmpeg-headless
    fuse-overlayfs # non-nixos
    glib # gio, gdbus
    libarchive # bsdtar
    me3
    umu-launcher # umu-run
    util-linux # flock, ionice, mountpoint
    vgmstream # vgmstream-cli
    xdg-utils # xdg-open, xdg-mime, xdg-settings
  ];

  versionCheckProgram = "${placeholder "out"}/bin/amethyst-mod-manager-cli";
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "amethyst_filegraph"
      ];
    };
  };

  meta = {
    description = "Linux native mod manager for a variety of games";
    homepage = "https://github.com/ChrisDKN/Amethyst-Mod-Manager";
    changelog = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/blob/${finalAttrs.src.tag}/Changelog.txt";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      RoGreat
      keenanweaver
    ];
    platforms = lib.platforms.linux;
    mainProgram = "amethyst-mod-manager";
  };
})
