{
  channel,
  version,
  hash,
}:

{
  fetchFromGitHub,
  gns3-server,
  lib,
  nixosTests,
  pkgsStatic,
  python3Packages,
  stdenv,
  testers,
  util-linux,
}:

python3Packages.buildPythonApplication {
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

  build-system = with python3Packages; [ setuptools ];

  dependencies =
    with python3Packages;
    [
      aiofiles
      aiohttp
      aiohttp-cors
      async-generator
      distro
      jinja2
      jsonschema
      multidict
      platformdirs
      prompt-toolkit
      psutil
      py-cpuinfo
      sentry-sdk
      truststore
      yarl
    ]
    ++ lib.optionals (pythonOlder "3.9") [
      importlib-resources
    ];

  postInstall = lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    rm $out/bin/gns3loopback
  '';

  # util-linux (script program) is required for Docker support
  makeWrapperArgs = [ "--suffix PATH : ${lib.makeBinPath [ util-linux ]}" ];

  doCheck = true;

  # Otherwise tests will fail to create directory
  # Permission denied: '/homeless-shelter'
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkInputs = with python3Packages; [
    pytest-aiohttp
    pytest-rerunfailures
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # fails on ofborg because of lack of cpu vendor information
    "--deselect=tests/controller/gns3vm/test_virtualbox_gns3_vm.py::test_cpu_vendor_id"
    # Rerun failed tests up to three times (flaky tests)
    "--reruns 3"
  ];

  passthru.tests = {
    inherit (nixosTests) gns3-server;
    version = testers.testVersion {
      package = gns3-server;
      command = "${lib.getExe gns3-server} --version";
    };
  };

  meta = {
    description = "Graphical Network Simulator 3 server (${channel} release)";
    longDescription = ''
      The GNS3 server manages emulators such as Dynamips, VirtualBox or
      Qemu/KVM. Clients like the GNS3 GUI control the server using a HTTP REST
      API.
    '';
    homepage = "https://www.gns3.com/";
    changelog = "https://github.com/GNS3/gns3-server/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ anthonyroussel ];
    mainProgram = "gns3server";
  };
}
