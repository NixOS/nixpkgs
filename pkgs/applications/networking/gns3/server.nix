{ stable, branch, version, sha256Hash, mkOverride, commonOverrides }:

{ lib, python3, fetchFromGitHub, packageOverrides ? self: super: {}
 }:

let
  defaultOverrides = commonOverrides ++ [
    (self: super: {
      aiofiles = super.aiofiles.overridePythonAttrs (oldAttrs: rec {
        pname = "aiofiles";
        version = "0.5.0";
        src = fetchFromGitHub {
          owner = "Tinche";
          repo = pname;
          rev = "v${version}";
          sha256 = "17bsg2x5r0q6jy74hajnbp717pvbf752w0wgih6pbb4hdvfg5lcf";
        };
        doCheck = false;
      });
    })
  ];

  python = python3.override {
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) ([ packageOverrides ] ++ defaultOverrides);
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
