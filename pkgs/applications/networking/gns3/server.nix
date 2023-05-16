<<<<<<< HEAD
{ channel
, version
, hash
=======
{ stable
, branch
, version
, sha256Hash
, mkOverride
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

{ lib
, python3
, fetchFromGitHub
<<<<<<< HEAD
, pkgsStatic
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3.pkgs.buildPythonApplication {
  pname = "gns3-server";
  inherit version;

  src = fetchFromGitHub {
<<<<<<< HEAD
    inherit hash;
    owner = "GNS3";
    repo = "gns3-server";
    rev = "refs/tags/v${version}";
  };

  # GNS3 2.3.26 requires a static BusyBox for the Docker integration
  prePatch = ''
    cp ${pkgsStatic.busybox}/bin/busybox gns3server/compute/docker/resources/bin/busybox
  '';
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

<<<<<<< HEAD
  pythonRelaxDeps = [
    "jsonschema"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = with python3.pkgs; [
    aiofiles
    aiohttp
    aiohttp-cors
<<<<<<< HEAD
    async-generator
=======
    async_generator
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    truststore
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    yarl
    zipstream
  ];

  # Requires network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/gns3loopback # For Windows only
  '';

  meta = with lib; {
<<<<<<< HEAD
    description = "Graphical Network Simulator 3 server (${channel} release)";
=======
    description = "Graphical Network Simulator 3 server (${branch} release)";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
