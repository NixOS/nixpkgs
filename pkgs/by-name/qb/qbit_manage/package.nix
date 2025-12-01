{
  lib,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  nix-update-script,
  qbit_manage,
}:
python3Packages.buildPythonApplication rec {
  pname = "qbit_manage";
  version = "4.6.5";

  src = fetchFromGitHub {
    owner = "StuffAnThings";
    repo = "qbit_manage";
    hash = "sha256-JCsbf2mPRhs7Mbekl946G/y/CSNSSvQBLvlwVy/Avcg=";
    tag = "v${version}";
  };

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  patches = [ ./bencodepy.patch ];

  dependencies = with python3Packages; [
    argon2-cffi
    bencode-py
    croniter
    fastapi
    gitpython
    humanize
    pytimeparse2
    qbittorrent-api
    requests
    retrying
    ruamel-yaml
    slowapi
    uvicorn
  ];

  pythonRelaxDeps = [
    "fastapi"
    "gitpython"
    "humanize"
    "ruamel.yaml"
    "uvicorn"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version =
        runCommand "qbit_manage-test-version"
          {
            buildInputs = [ qbit_manage ];
          }
          ''
            export HOME=$TMPDIR # Needed since qbit-manage creates config files in home dir
            outver="$(qbit-manage --version)"
            echo "$outver" | grep -q "${version}" \
              || (echo "Version mismatch: $outver" >&2; exit 1)
            touch $out
          '';
    };
  };

  meta = {
    description = "This tool will help manage tedious tasks in qBittorrent and automate them";
    homepage = "https://github.com/StuffAnThings/qbit_manage";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flyingpeakock ];
    platforms = lib.platforms.all;
    mainProgram = "qbit-manage";
  };
}
