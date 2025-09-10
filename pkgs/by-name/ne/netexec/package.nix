{
  lib,
  stdenv,
  fetchFromGitHub,
  python312,
  writableTmpDirAsHomeHook,
}:
let
  python = python312.override {
    self = python;
    packageOverrides = self: super: {
      impacket = super.impacket.overridePythonAttrs {
        version = "0.12.0-unstable-2025-03-14";
        src = fetchFromGitHub {
          owner = "fortra";
          repo = "impacket";
          rev = "8b4566b12fc79acb520d045dbae8f13446a9d4d7";
          hash = "sha256-jyn5qSSAipGYhHm2EROwDHa227mnmW+d+0H0/++i1OY=";
        };
        # Fix version to be compliant with Python packaging rules
        postPatch = ''
          substituteInPlace setup.py \
            --replace 'version="{}.{}.{}.{}{}"' 'version="{}.{}.{}"'
        '';
      };
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "netexec";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Pennyw0rth";
    repo = "NetExec";
    tag = "v${version}";
    hash = "sha256-1yNnnPntJ5aceX3Z8yYAMLv5bSFfCFVp0pgxAySlVfE=";
  };

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    # Fail to detect dev version requirement
    "neo4j"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " @ git+https://github.com/fortra/impacket.git" "" \
      --replace-fail " @ git+https://github.com/wbond/oscrypto" "" \
      --replace-fail " @ git+https://github.com/Pennyw0rth/NfsClient" ""
  '';

  build-system = with python.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python.pkgs; [
    jwt
    aardwolf
    aioconsole
    aiosqlite
    argcomplete
    asyauth
    beautifulsoup4
    bloodhound-py
    dploot
    dsinternals
    impacket
    lsassy
    masky
    minikerberos
    msgpack
    msldap
    neo4j
    paramiko
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

  nativeCheckInputs = with python.pkgs; [ pytestCheckHook ] ++ [ writableTmpDirAsHomeHook ];

  # Tests no longer works out-of-box with 1.3.0
  doCheck = false;

  meta = {
    description = "Network service exploitation tool (maintained fork of CrackMapExec)";
    homepage = "https://github.com/Pennyw0rth/NetExec";
    changelog = "https://github.com/Pennyw0rth/NetExec/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ vncsb ];
    mainProgram = "nxc";
    # FIXME: failing fixupPhase:
    # $ Rewriting #!/nix/store/<hash>-python3-3.11.7/bin/python3.11 to #!/nix/store/<hash>-python3-3.11.7
    # $ /nix/store/<hash>-wrap-python-hook/nix-support/setup-hook: line 65: 47758 Killed: 9               sed -i "$f" -e "1 s^#!/nix/store/<hash>-python3-3.11.7^#!/nix/store/<hash>-python3-3.11.7^"
    broken = stdenv.hostPlatform.isDarwin;
  };
}
