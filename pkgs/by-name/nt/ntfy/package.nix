{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  fetchpatch,
  withXmpp ? false, # sleekxmpp doesn't support python 3.10, see https://github.com/dschep/ntfy/issues/266
  withMatrix ? true,
  withSlack ? true,
  withEmoji ? true,
  withPid ? true,
  withDbus ? stdenv.hostPlatform.isLinux,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      ntfy-webpush = self.callPackage ./webpush.nix { };

      # databases, on which slack-sdk depends, is incompatible with SQLAlchemy 2.0
      sqlalchemy = super.sqlalchemy_1_4;
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "ntfy";
  version = "2.7.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "dschep";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "09f02cn4i1l2aksb3azwfb70axqhn7d0d0vl2r6640hqr74nc1cv";
  };

  patches = [
    # Fix Slack integration no longer working.
    # From https://github.com/dschep/ntfy/pull/229 - "Swap Slacker for Slack SDK"
    (fetchpatch {
      name = "ntfy-Swap-Slacker-for-Slack-SDK.patch";
      url = "https://github.com/dschep/ntfy/commit/2346e7cfdca84c8f1afc7462a92145c1789deb3e.patch";
      sha256 = "13k7jbsdx0jx7l5s8whirric76hml5bznkfcxab5xdp88q52kpk7";
    })
    # Add compatibility with emoji 2.0
    # https://github.com/dschep/ntfy/pull/250
    (fetchpatch {
      name = "ntfy-Add-compatibility-with-emoji-2.0.patch";
      url = "https://github.com/dschep/ntfy/commit/4128942bb7a706117e7154a50a73b88f531631fe.patch";
      sha256 = "sha256-V8dIy/K957CPFQQS1trSI3gZOjOcVNQLgdWY7g17bRw=";
    })
    # Change getargspec to getfullargspec for python 3.11 compatibility
    (fetchpatch {
      url = "https://github.com/dschep/ntfy/commit/71be9766ea041d2df6ebbce2781f980eea002852.patch";
      hash = "sha256-6OChaTj4g3gxVDScc/JksBISHuq+5fbNQregchSXYaQ=";
    })
    # Fix compatibility with Python 3.11
    # https://github.com/dschep/ntfy/pull/271
    (fetchpatch {
      url = "https://github.com/dschep/ntfy/pull/271/commits/444b60bec7de474d029cac184e82885011dd1474.patch";
      hash = "sha256-PKTu8cOpws1z6f1T4uIi2iCJAoAwu+X0Pe7XnHYtHuI=";
    })
    # Fix compatibility with Python 3.12
    # https://github.com/dschep/ntfy/pull/271
    (fetchpatch {
      url = "https://github.com/dschep/ntfy/pull/271/commits/d49ab9f9dba4966a44b5f0c6911741edabd35f6b.patch";
      hash = "sha256-qTUWMS8EXWYCK/ZL0Us7iJp62UIKwYT1BqDy59832ig=";
    })
  ];

  postPatch = ''
    # We disable the Darwin specific things because it relies on pyobjc, which we don't have.
    substituteInPlace setup.py \
      --replace-fail "':sys_platform == \"darwin\"'" "'darwin'"
  '';

  build-system = with python.pkgs; [ setuptools ];

  dependencies =
    with python.pkgs;
    (
      [
        requests
        ruamel-yaml
        appdirs
        ntfy-webpush
      ]
      ++ lib.optionals withXmpp [
        sleekxmpp
        dnspython
      ]
      ++ lib.optionals withMatrix [
        matrix-client
      ]
      ++ lib.optionals withSlack [
        slack-sdk
      ]
      ++ lib.optionals withEmoji [
        emoji
      ]
      ++ lib.optionals withPid [
        psutil
      ]
      ++ lib.optionals withDbus [
        dbus-python
      ]
    );

  nativeCheckInputs = with python.pkgs; [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    "test_xmpp"
  ];

  disabledTestPaths = [
    "tests/test_xmpp.py"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "ntfy" ];

  meta = with lib; {
    description = "Utility for sending notifications, on demand and when commands finish";
    homepage = "https://ntfy.readthedocs.io/en/latest/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ kamilchm ];
    mainProgram = "ntfy";
  };
}
