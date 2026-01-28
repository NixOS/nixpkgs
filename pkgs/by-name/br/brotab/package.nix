{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "brotab";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "balta2ar";
    repo = "brotab";
    tag = version;
    hash = "sha256-Pv5tEDL11brc/n3TuFcad9kTr7Jb/Bt7JFb29HuX/28=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    flask
    psutil
    requests
    werkzeug
    setuptools
  ];

  pythonRelaxDeps = [
    "flask"
    "psutil"
    "requests"
    "werkzeug"
    "setuptools"
  ];

  postInstall = ''
    substituteInPlace $out/config/*json \
      --replace-fail '$PWD/brotab_mediator.py' $out/bin/bt_mediator
    mkdir -p $out/lib/mozilla/native-messaging-hosts
    mv $out/config/firefox_mediator.json $out/lib/mozilla/native-messaging-hosts
    mkdir -p $out/etc/chromium/native-messaging-hosts
    mv $out/config/chromium_mediator.json $out/etc/chromium/native-messaging-hosts
    mkdir -p $out/lib/albert
    mv $out/config/Brotab.qss $out/lib/albert
    rmdir $out/config
  '';

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/balta2ar/brotab";
    description = "Control your browser's tabs from the command line";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
