{ stable, branch, version, sha256Hash, mkOverride, commonOverrides }:

{ lib, python3, fetchFromGitHub }:

let
  defaultOverrides = commonOverrides ++ [
    (mkOverride "aiofiles" "0.5.0"
      "98e6bcfd1b50f97db4980e182ddd509b7cc35909e903a8fe50d8849e02d815af")
  ];

  python = python3.override {
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) defaultOverrides;
  };
in python.pkgs.buildPythonPackage {
  pname = "gns3-server";
  inherit version;

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "gns3-server";
    rev = "v${version}";
    sha256 = sha256Hash;
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "aiohttp==3.6.2" "aiohttp>=3.6.2" \
      --replace "py-cpuinfo==7.0.0" "py-cpuinfo>=8.0.0"
  '';

  propagatedBuildInputs = with python.pkgs; [
    aiohttp-cors yarl aiohttp multidict setuptools
    jinja2 psutil zipstream sentry-sdk jsonschema distro async_generator aiofiles
    prompt-toolkit py-cpuinfo
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
    maintainers = with maintainers; [ ];
  };
}
