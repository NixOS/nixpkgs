{ stable, branch, version, sha256Hash }:

{ stdenv, python3Packages, fetchFromGitHub, fetchurl }:

let
  pythonPackages = python3Packages;
  yarl = if (!stable) then pythonPackages.yarl
    else (stdenv.lib.overrideDerivation pythonPackages.yarl (oldAttrs:
      rec {
        pname = "yarl";
        version = "0.9.8";
        name = "${pname}-${version}";
        src = pythonPackages.fetchPypi {
          inherit pname version;
          sha256 = "1v2dsmr7bqp0yx51pwhbxyvzza8m2f88prsnbd926mi6ah38p0d7";
        };
      }));
  aiohttp = if (!stable) then pythonPackages.aiohttp
    else (stdenv.lib.overrideDerivation pythonPackages.aiohttp (oldAttrs:
      rec {
        pname = "aiohttp";
        version = "1.3.5";
        name = "${pname}-${version}";
        src = pythonPackages.fetchPypi {
          inherit pname version;
          sha256 = "0hpqdiaifgyfqmxkyzwypwvrnvz5rqzgzylzhihfidc5ldfs856d";
        };
        propagatedBuildInputs = [ yarl ]
          ++ (with pythonPackages; [ async-timeout chardet multidict ]);
      }));
  aiohttp-cors = if (!stable) then pythonPackages.aiohttp-cors
    else (stdenv.lib.overrideDerivation pythonPackages.aiohttp-cors (oldAttrs:
      rec {
        pname = "aiohttp-cors";
        version = "0.5.1";
        name = "${pname}-${version}";
        src = pythonPackages.fetchPypi {
          inherit pname version;
          sha256 = "0szma27ri25fq4nwwvs36myddggw3jz4pyzmq63yz4xpw0jjdxck";
        };
        propagatedBuildInputs = [ aiohttp ];
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

  propagatedBuildInputs = [ yarl aiohttp aiohttp-cors ]
    ++ (with pythonPackages; [
      jinja2 psutil zipstream raven jsonschema typing
      prompt_toolkit
    ]);

  postPatch = stdenv.lib.optionalString (!stable) ''
    sed -i 's/yarl>=0.11,<0.12/yarl/g' requirements.txt
  '';

  # Requires network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/gns3loopback # For windows only
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
