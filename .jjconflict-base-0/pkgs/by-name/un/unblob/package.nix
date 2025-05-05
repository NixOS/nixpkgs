{
  lib,
  libiconv,
  python3,
  fetchFromGitHub,
  gitUpdater,
  makeWrapper,
  rustPlatform,
  stdenvNoCC,
  e2fsprogs,
  erofs-utils,
  jefferson,
  lz4,
  lziprecover,
  lzop,
  p7zip,
  sasquatch,
  sasquatch-v4be,
  simg2img,
  ubi_reader,
  unar,
  zstd,
  versionCheckHook,
}:

let
  # These dependencies are only added to PATH
  runtimeDeps = [
    e2fsprogs
    erofs-utils
    jefferson
    lziprecover
    lzop
    p7zip
    sasquatch
    sasquatch-v4be
    ubi_reader
    simg2img
    unar
    zstd
    lz4
  ];
in
python3.pkgs.buildPythonApplication rec {
  pname = "unblob";
  version = "25.4.14";
  pyproject = true;
  disabled = python3.pkgs.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = "unblob";
    tag = version;
    hash = "sha256-kWZGQX8uSKdFW+uauunHcruXhJ5XpBfyDY7gPyWGK90=";
    forceFetchGit = true;
    fetchLFS = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-lGsDax7+CUACeYChDqdPsVbKE/hH94CPek6UBVz1eqs=";
  };

  strictDeps = true;

  build-system = with python3.pkgs; [ poetry-core ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isDarwin [ libiconv ];

  dependencies = with python3.pkgs; [
    arpy
    attrs
    click
    cryptography
    dissect-cstruct
    lark
    lief.py
    python3.pkgs.lz4 # shadowed by pkgs.lz4
    plotext
    pluggy
    pyfatfs
    pyperscan
    python-magic
    pyzstd
    rarfile
    rich
    structlog
    treelib
  ];

  nativeBuildInputs = with rustPlatform; [
    makeWrapper
    maturinBuildHook
    cargoSetupHook
  ];

  # These are runtime-only CLI dependencies, which are used through
  # their CLI interface
  pythonRemoveDeps = [
    "jefferson"
    "ubi-reader"
  ];

  pythonRelaxDeps = [ "lz4" ];

  pythonImportsCheck = [ "unblob" ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath runtimeDeps}"
  ];

  nativeCheckInputs =
    with python3.pkgs;
    [
      pytestCheckHook
      pytest-cov
      versionCheckHook
    ]
    ++ runtimeDeps;

  versionCheckProgramArg = "--version";

  pytestFlagsArray =
    let
      # `disabledTests` swallows the parameters between square brackets
      disabled = [
        # https://github.com/tytso/e2fsprogs/issues/152
        "test_all_handlers[filesystem.extfs]"
      ];
    in
    [
      "--no-cov"
      "-k 'not ${lib.concatStringsSep " and not " disabled}'"
    ];

  passthru = {
    updateScript = gitUpdater { };
    # helpful to easily add these to a nix-shell environment
    inherit runtimeDeps;
  };

  meta = {
    description = "Extract files from any kind of container formats";
    homepage = "https://unblob.org";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "unblob";
    maintainers = with lib.maintainers; [ vlaci ];
  };
}
