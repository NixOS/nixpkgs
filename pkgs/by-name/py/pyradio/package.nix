{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:

python3Packages.buildPythonApplication rec {
  pname = "pyradio";
  version = "0.9.3.11.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coderholic";
    repo = "pyradio";
    tag = version;
    hash = "sha256-JUVlaKKprgnGiZzZ0J6VSePrSdCWuWQzhuTTiCeB12U=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    dnspython
    netifaces
    psutil
    python-dateutil
    requests
    rich
  ];

  postPatch = ''
    # Disable update check
    substituteInPlace pyradio/config \
      --replace-fail "distro = None" "distro = NixOS"
  '';

  checkPhase = ''
    $out/bin/pyradio --help
  '';

  postInstall = ''
    installManPage *.1
  '';

  meta = {
    homepage = "http://www.coderholic.com/pyradio/";
    description = "Curses based internet radio player";
    mainProgram = "pyradio";
    changelog = "https://github.com/coderholic/pyradio/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      contrun
      yayayayaka
    ];
  };
}
