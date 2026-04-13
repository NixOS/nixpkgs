{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "netexec";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Pennyw0rth";
    repo = "NetExec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BKqBmpA2cSKwC9zX++Z6yTSDIyr4iZVGC/Eea6zoMLQ=";
  };

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    # Fail to detect dev version requirement
    "neo4j"
    # No python package in nixpkgs; use bloodhound-py instead.
    "bloodhound-ce"
    # Set as git depenencies
    "oscrypto"
    "certipy-ad"
    "impacket"
    "pynfsclient"
  ];

  postPatch = ''
    substituteInPlace nxc/first_run.py \
      --replace-fail "from os import mkdir" "from os import mkdir, chmod" \
      --replace-fail "shutil.copy(default_path, NXC_PATH)" $'shutil.copy(default_path, CONFIG_PATH)\n        chmod(CONFIG_PATH, 0o600)'
  '';

  build-system = with python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python3.pkgs; [
    jwt
    aardwolf
    aioconsole
    aiosqlite
    argcomplete
    asyauth
    beautifulsoup4
    bloodhound-py
    certihound
    certipy-ad
    dploot
    dsinternals
    impacket
    lsassy
    masky
    minikerberos
    msgpack
    neo4j
    oscrypto
    paramiko
    pefile
    pyasn1-modules
    pylnk3
    pynfsclient
    pypsrp
    pypykatz
    python-dateutil
    python-libnmap
    pywerview
    requests
    rich
    sqlalchemy
    termcolor
    terminaltables
    xmltodict
  ];

  nativeCheckInputs =
    with python3.pkgs;
    [ pytestCheckHook ]
    ++ [
      writableTmpDirAsHomeHook
      versionCheckHook
    ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Network service exploitation tool (maintained fork of CrackMapExec)";
    homepage = "https://github.com/Pennyw0rth/NetExec";
    changelog = "https://github.com/Pennyw0rth/NetExec/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      vncsb
      letgamer
    ];
    mainProgram = "nxc";
    # FIXME: failing fixupPhase:
    # $ Rewriting #!/nix/store/<hash>-python3-3.11.7/bin/python3.11 to #!/nix/store/<hash>-python3-3.11.7
    # $ /nix/store/<hash>-wrap-python-hook/nix-support/setup-hook: line 65: 47758 Killed: 9               sed -i "$f" -e "1 s^#!/nix/store/<hash>-python3-3.11.7^#!/nix/store/<hash>-python3-3.11.7^"
    broken = stdenv.hostPlatform.isDarwin;
  };
})
