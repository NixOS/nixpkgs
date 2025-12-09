{
  lib,
  python3,
  fetchFromGitLab,
  nix-update-script,
}:
let
  version = "1.43";
in
python3.pkgs.buildPythonApplication {
  pname = "dput-ng";
  inherit version;
  pyproject = true;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "dput-ng";
    tag = "debian/${version}";
    hash = "sha256-zrH4h4C4y3oTiOXsidFv/rIJNzCdV2lqzNEg0SOkX4w=";
  };

  postPatch = ''
    substituteInPlace dput/core.py --replace-fail /usr/share/dput-ng "$out/share/dput-ng"
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    jsonschema
    paramiko
    sphinx
    coverage
    xdg
    python-debian
    distro-info
  ];

  postInstall = ''
    cp -r bin $out/
    mkdir -p "$out/share/dput-ng"
    cp -r skel/* "$out/share/dput-ng/"
  '';

  pythonImportsCheck = [ "dput" ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  # Requires running dpkg
  disabledTestPaths = [ "tests/test_upload.py" ];

  passthru.updateScript = nix-update-script {
    # Debian's tagging scheme is the bane of my existence.
    # Essentially: all tags from 1.40 onwards start with `debian/`,
    # then the version, and then an optional suffix (usually reserved for backports).
    # We want to ignore the backport versions, and strip the `debian/` prefix.
    extraArgs = [ "--version-regex=(?:debian\/)?(\d+(?:\.\d+)*)(?:[_\+].*)?" ];
  };

  meta = {
    description = "Next-generation Debian package upload tool";
    homepage = "https://dput.readthedocs.io/en/latest/";
    license = with lib.licenses; [ gpl2Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "dput";
  };
}
