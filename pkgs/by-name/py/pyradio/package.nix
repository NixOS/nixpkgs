{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:

python3Packages.buildPythonApplication rec {
  pname = "pyradio";
  version = "0.9.3.11.5";

  src = fetchFromGitHub {
    owner = "coderholic";
    repo = "pyradio";
    tag = version;
    hash = "sha256-+guMfdYmXnWARyl5TQVUk2jCkIs11I5d0PMlCzs4ZFo=";
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
