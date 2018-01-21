{ stable, branch, version, sha256Hash }:

{ stdenv, python3Packages, fetchFromGitHub, fetchurl }:

let
  pythonPackages = python3Packages;
  aiohttp-cors = (stdenv.lib.overrideDerivation pythonPackages.aiohttp-cors
    (oldAttrs:
      rec {
        pname = "aiohttp-cors";
        version = "0.5.3";
        name = "${pname}-${version}";
        src = pythonPackages.fetchPypi {
          inherit pname version;
          sha256 = "11b51mhr7wjfiikvj3nc5s8c7miin2zdhl3yrzcga4mbpkj892in";
        };
      }));
in pythonPackages.buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "gns3-server";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = sha256Hash;
  };

  propagatedBuildInputs = [ aiohttp-cors ]
    ++ (with pythonPackages; [
      yarl aiohttp multidict
      jinja2 psutil zipstream raven jsonschema typing
      prompt_toolkit
    ]);

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
