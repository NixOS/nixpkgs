{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  qt6,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "retool";
  version = "2.4.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unexpectedpanda";
    repo = "retool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SSSHYwQtDtCONvM5Ze3G5JJ4TW5aCziS3EbxhliXx+g=";
  };

  pythonRelaxDeps = true;

  postPatch = ''
    # Upstream uses hatch-pyinstaller for a separate frozen-app target, but nixpkgs
    # only builds the wheel. Keeping it in build-system.requires makes the wheel build
    # fail unless the optional plugin is packaged too.
    substituteInPlace pyproject.toml \
      --replace-fail '"hatch-pyinstaller",' ""

    # Retool derives its config/download directory from sys.argv[0], which points
    # into the immutable Nix store. Redirect its mutable state to RETOOL_HOME or
    # the current working directory instead.
    substituteInPlace modules/config/config.py \
      --replace-fail \
        "self.retool_location: pathlib.Path = pathlib.Path(sys.argv[0]).resolve().parent" \
        "self.retool_location: pathlib.Path = pathlib.Path(os.environ.get('RETOOL_HOME', pathlib.Path.cwd())).expanduser()"
  '';

  build-system = with python3.pkgs; [ hatchling ];

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = [
    qt6.qtbase
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    qt6.qtwayland
  ];

  dependencies = with python3.pkgs; [
    alive-progress
    darkdetect
    lxml
    psutil
    pyside6
    strictyaml
    validators
  ];

  # Upstream has no tests
  doCheck = false;

  meta = {
    description = "Better filter tool for Redump and No-Intro dats";
    homepage = "https://github.com/unexpectedpanda/retool";
    changelog = "https://github.com/unexpectedpanda/retool/blob/${finalAttrs.src.tag}/changelog.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thiagokokada ];
  };
})
