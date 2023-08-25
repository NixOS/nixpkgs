{ channel
, version
, hash
}:

{ lib
, python3
, fetchFromGitHub
, pkgsStatic
}:

python3.pkgs.buildPythonApplication {
  pname = "gns3-server";
  inherit version;

  src = fetchFromGitHub {
    inherit hash;
    owner = "GNS3";
    repo = "gns3-server";
    rev = "refs/tags/v${version}";
  };

  # GNS3 2.3.26 requires a static BusyBox for the Docker integration
  prePatch = ''
    cp ${pkgsStatic.busybox}/bin/busybox gns3server/compute/docker/resources/bin/busybox
  '';

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "jsonschema"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiofiles
    aiohttp
    aiohttp-cors
    async-generator
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
    truststore
    yarl
    zipstream
  ];

  # Requires network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/gns3loopback # For Windows only
  '';

  meta = with lib; {
    description = "Graphical Network Simulator 3 server (${channel} release)";
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
