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
  writableTmpDirAsHomeHook,
  writeScript,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gns3-server";
  version = "2.2.56.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "gns3-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1eYUJtrOfe1DXzxJbT1HQ6oiiiS+xHRG/wg9gOs0uTU=";
  };

  # GNS3 2.3.26 requires a static BusyBox for the Docker integration
  prePatch = ''
    cp ${pkgsStatic.busybox}/bin/busybox gns3server/compute/docker/resources/bin/busybox
  '';

  pythonRelaxDeps = [
    "aiofiles"
    "aiohttp"
    "aiohttp-cors"
    "jsonschema"
    "platformdirs"
    "psutil"
    "sentry-sdk"
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    aiofiles
    aiohttp
    aiohttp-cors
    async-generator
    async-timeout
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
  ];

  postInstall = lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    rm $out/bin/gns3loopback
  '';

  # util-linux (script program) is required for Docker support
  makeWrapperArgs = [ "--suffix PATH : ${lib.makeBinPath [ util-linux ]}" ];

  nativeCheckInputs = with python3Packages; [
    pytest-aiohttp
    pytest-rerunfailures
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pytestFlags = [
    # Rerun failed tests up to three times (flaky tests)
    "--reruns=3"
  ];

  disabledTestPaths = [
    # fails on ofborg because of lack of cpu vendor information
    "tests/controller/gns3vm/test_virtualbox_gns3_vm.py::test_cpu_vendor_id"
    "tests/controller/test_project.py"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) gns3-server;
      version = testers.testVersion {
        package = gns3-server;
        command = "${lib.getExe gns3-server} --version";
      };
    };
    updateScript = writeScript "update-gns3" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update

      set -eu -o pipefail

      nix-update gns3-gui --version-regex '^v(2\.[\d\.]+)$' --commit
      nix-update gns3-server --version-regex '^v(2\.[\d\.]+)$' --commit
    '';
  };

  meta = {
    description = "Graphical Network Simulator 3 server";
    longDescription = ''
      The GNS3 server manages emulators such as Dynamips, VirtualBox or
      Qemu/KVM. Clients like the GNS3 GUI control the server using a HTTP REST
      API.
    '';
    homepage = "https://www.gns3.com/";
    changelog = "https://github.com/GNS3/gns3-server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ anthonyroussel ];
    mainProgram = "gns3server";
  };
})
