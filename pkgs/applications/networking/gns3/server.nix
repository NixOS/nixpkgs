{ stable, branch, version, sha256Hash }:

{ stdenv, python3Packages, fetchFromGitHub, fetchurl }:

let
  pythonPackages = python3Packages;
  async-timeout = (stdenv.lib.overrideDerivation pythonPackages.async-timeout
    (oldAttrs:
      rec {
        pname = "async-timeout";
        version = "2.0.1";
        src = pythonPackages.fetchPypi {
          inherit pname version;
          sha256 = "1l3kg062m02mph6rf9rdv8r5c5n356clxa6b6mrn0i77vk9g9kq0";
        };
      }));
  aiohttp = (stdenv.lib.overrideDerivation pythonPackages.aiohttp
    (oldAttrs:
      rec {
        pname = "aiohttp";
        version = "2.3.10";
        src = pythonPackages.fetchPypi {
          inherit pname version;
          sha256 = "8adda6583ba438a4c70693374e10b60168663ffa6564c5c75d3c7a9055290964";
        };
        propagatedBuildInputs = [ async-timeout ]
          ++ (with pythonPackages; [ attrs chardet multidict yarl ])
          ++ stdenv.lib.optional (pythonPackages.pythonOlder "3.7") pythonPackages.idna-ssl;
      }));
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
        propagatedBuildInputs = [ aiohttp ]
          ++ stdenv.lib.optional
               (pythonPackages.pythonOlder "3.5")
               pythonPackages.typing;
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
