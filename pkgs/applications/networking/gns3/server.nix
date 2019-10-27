{ stable, branch, version, sha256Hash }:

{ stdenv, python3, fetchFromGitHub }:

let
  python = python3;

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
    # Only 2.x is problematic:
    sed -iE "s/prompt-toolkit==1.0.15/prompt-toolkit<2.0.0/" requirements.txt
  '';

  propagatedBuildInputs = with python.pkgs; [
    aiohttp-cors yarl aiohttp multidict setuptools
    jinja2 psutil zipstream raven jsonschema distro async_generator aiofiles
    (python.pkgs.callPackage ../../../development/python-modules/prompt_toolkit/1.nix {})
  ];

  # Requires network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/gns3loopback # For Windows only
  '';

  meta = with stdenv.lib; {
    description = "Graphical Network Simulator 3 server (${branch} release)";
    longDescription = ''
      The GNS3 server manages emulators such as Dynamips, VirtualBox or
      Qemu/KVM. Clients like the GNS3 GUI control the server using a HTTP REST
      API.
    '';
    homepage = https://www.gns3.com/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
