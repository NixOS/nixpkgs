{
  lib,
  fetchPypi,
  python3Packages,
  sshuttle,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sshoot";
  version = "1.6.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-NaT1XZTriuz7h1qgba3MOA2scqLjawYtn98H17RHMzA=";
  };

  build-system = [ python3Packages.setuptools ];

  postPatch = ''
    substituteInPlace sshoot/manager.py \
      --replace-fail '"sshuttle"' '"${lib.getExe sshuttle}"'
  '';

  dependencies = with python3Packages; [
    argcomplete
    prettytable
    pyyaml
    pyxdg
    toolrack
  ];

  doCheck = false;

  pythonImportsCheck = [ "sshoot" ];

  meta = {
    homepage = "https://github.com/albertodonato/sshoot";
    description = "Manage sshuttle VPN sessions";
    longDescription = ''
      Command-line interface to manage multiple sshuttle VPN sessions.
      sshuttle creates a VPN connection from your machine to any remote server that you can connect to via ssh.
      sshoot allows to define multiple VPN sessions using sshuttle and start/stop them as needed.
      It supports configuration options for most of sshuttle's features, providing flexible configuration for profiles.
    '';
    mainProgram = "sshoot";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jeanralphaviles ];
  };
})
