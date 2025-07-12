{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:

python3Packages.buildPythonApplication rec {
  pname = "pyradio";
  version = "0.9.3.11.15";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coderholic";
    repo = "pyradio";
    tag = version;
    hash = "sha256-xOEn01QrVlgXhFdO3YbR5+k7vkez//Y+YSKTI8C4uqA=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = with python3Packages; [
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
