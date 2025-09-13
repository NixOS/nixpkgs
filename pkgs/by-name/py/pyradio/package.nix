{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:

python3Packages.buildPythonApplication rec {
  pname = "pyradio";
  version = "0.9.3.11.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coderholic";
    repo = "pyradio";
    tag = version;
    hash = "sha256-PogdBixxr50M5J4hp158KAhs6+2E3ILCC44MAh222QY=";
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

  meta = with lib; {
    homepage = "http://www.coderholic.com/pyradio/";
    description = "Curses based internet radio player";
    mainProgram = "pyradio";
    changelog = "https://github.com/coderholic/pyradio/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [
      contrun
      yayayayaka
    ];
  };
}
