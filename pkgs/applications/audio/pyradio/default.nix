{ lib
, python3Packages
, fetchFromGitHub
, installShellFiles
}:

python3Packages.buildPythonApplication rec {
  pname = "pyradio";
  version = "0.9.3.1";

  src = fetchFromGitHub {
    owner = "coderholic";
    repo = "pyradio";
    rev = "refs/tags/${version}";
    hash = "sha256-p3F4uN+hkxGp+216abUkFNM5uF/0e0sQHKk5WIpULso=";
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
    changelog = "https://github.com/coderholic/pyradio/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ contrun yayayayaka ];
  };
}
