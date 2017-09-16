{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "gns3-server";
  version = "2.1.0rc1";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = "181689fpjxq4hy2lyxk4zciqhgnhj5srvb4xsxdlbf68n89fj2zf";
  };

  propagatedBuildInputs = with python3Packages; [
    aiohttp jinja2 psutil zipstream aiohttp-cors raven jsonschema yarl typing
    prompt_toolkit
  ];

  postPatch = ''
    sed -i 's/yarl>=0.11,<0.12/yarl/g' requirements.txt
  '';

  # Requires network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/gns3loopback # For windows only
  '';
  meta = with stdenv.lib; {
    description = "Graphical Network Simulator 3 server";
    longDescription = ''
      The GNS3 server manages emulators such as Dynamips, VirtualBox or
      Qemu/KVM. Clients like the GNS3 GUI control the server using a HTTP REST
      API.
    '';
    homepage = "https://www.gns3.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
