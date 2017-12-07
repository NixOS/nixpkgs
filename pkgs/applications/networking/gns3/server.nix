{ stdenv, python34Packages, fetchFromGitHub }:

python34Packages.buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "gns3-server";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c7mzj1r2zh90a7vs3s17jakfp9s43b8nnj29rpamqxvl3qhbdy7";
  };

  propagatedBuildInputs = with python34Packages; [
    aiohttp jinja2 psutil zipstream aiohttp-cors raven jsonschema
  ];

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
