{
  _7zz,
  bash,
  cabextract,
  curl,
  fetchFromGitHub,
  glib,
  lib,
  libarchive,
  me3,
  meson,
  ninja,
  python3Packages,
  qt6,
  rustPlatform,
  umu-launcher,
  vgmstream,
  winetricks,
  xdg-utils,
}:
let
  version = "2.4.0";
  src = fetchFromGitHub {
    owner = "ChrisDKN";
    repo = "Amethyst-Mod-Manager";
    tag = "v${version}";
    hash = "sha256-M6moW1cw0mLU3N5sAAdXmLTKP+gF7BAkZWcJFp96wxI=";
  };

  amethyst-filegraph = rustPlatform.buildRustPackage {
    inherit src;
    pname = "amethyst-filegraph";
    version = "0.1.0";
    sourceRoot = "${src.name}/native/amethyst_filegraph";
    cargoHash = "sha256-PGyUuwwU44/0lHfHEipgi5TxGyXbdDPar/mDqHLFsgM=";
  };
in
python3Packages.buildPythonApplication {
  inherit src version;
  pname = "amethyst-mod-manager";
  pyproject = false;

  nativeBuildInputs = [
    meson
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  dependencies = with python3Packages; [
    # requirements-vendor.txt
    py7zr
    pillow
    lz4
    zstandard
    requests
    keyring
    jeepney
    msgpack
    bsdiff4
    cryptography
    secretstorage
    certifi
    # not in requirements-vendor.txt
    libloot
    pyside6
  ];

  postPatch = ''
    patchShebangs src/version.py

    # amethyst_filegraph
    install ${amethyst-filegraph}/lib/libamethyst_filegraph.so src/amethyst_filegraph.abi3.so

    # get_tools_dir
    substituteInPlace src/Utils/protontricks.py \
        --replace-fail '_get_tools_dir() / "winetricks"' 'Path("${lib.getExe winetricks}")' \
        --replace-fail '_get_tools_dir() / "cabextract"' 'Path("${lib.getExe cabextract}")'

    # --nxm %u
    substituteInPlace src/Nexus/nxm_handler.py \
        --replace-fail \
            "f'{cls._quote_if_needed(exe)} {cls._quote_if_needed(script)} --nxm %u'" \
            "'amethyst-mod-manager --nxm %u'"
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=(
        --set PYTHONPATH "$out/${python3Packages.python.sitePackages}:$PYTHONPATH"
        --suffix PATH : "${
          lib.makeBinPath [
            _7zz
            bash
            curl
            glib # gio, gdbus
            libarchive # bsdtar
            me3
            python3Packages.python
            umu-launcher # umu-run
            vgmstream # vgmstream-cli
            xdg-utils # xdg-open, xdg-mime, xdg-settings
          ]
        }"
    )
    wrapQtApp $out/bin/amethyst-mod-manager ''${makeWrapperArgs[@]}
    wrapProgram $out/bin/amethyst-mod-manager-cli ''${makeWrapperArgs[@]}
    rm -r $out/share/metainfo
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "cli"
    "run_qt"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Linux native mod manager for a variety of games";
    homepage = "https://github.com/ChrisDKN/Amethyst-Mod-Manager";
    changelog = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/blob/${src.tag}/Changelog.txt";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "amethyst-mod-manager";
    platforms = lib.platforms.linux;
  };
}
