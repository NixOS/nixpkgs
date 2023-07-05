{ stable
, branch
, version
, sha256Hash
, mkOverride
}:

{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication {
  pname = "gns3-server";
  inherit version;

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "gns3-server";
    rev = "refs/tags/v${version}";
    sha256 = sha256Hash;
  };

  pythonRelaxDeps = [
    "aiofiles"
    "jsonschema"
    "psutil"
    "sentry-sdk"
  ];

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiofiles
    aiohttp
    aiohttp-cors
    async_generator
    distro
    importlib-resources
    jinja2
    jsonschema
    multidict
    prompt-toolkit
    psutil
    py-cpuinfo
    sentry-sdk
    setuptools
    yarl
    zipstream
  ];

  # Requires network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/gns3loopback # For Windows only
  '';

  meta = with lib; {
    description = "Graphical Network Simulator 3 server (${branch} release)";
    longDescription = ''
      The GNS3 server manages emulators such as Dynamips, VirtualBox or
      Qemu/KVM. Clients like the GNS3 GUI control the server using a HTTP REST
      API.
    '';
    homepage = "https://www.gns3.com/";
    changelog = "https://github.com/GNS3/gns3-server/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
