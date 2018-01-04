{ stable, branch, version, sha256Hash }:

{ stdenv, python3Packages, fetchFromGitHub, fetchurl }:

let
  pythonPackages = python3Packages;
  # TODO: Not sure if all these overwrites are really required...
  # Upstream seems to have some reasons (bugs, incompatibilities) though.
  multidict_3_1_3 =
    (stdenv.lib.overrideDerivation pythonPackages.multidict (oldAttrs:
      rec {
        pname = "multidict";
        version = "3.1.3";
        name = "${pname}-${version}";
        src = pythonPackages.fetchPypi {
          inherit pname version;
          sha256 = "04kdxh19m41c6vbshwk8jfbidsfsqn7mn0abvx09nyg78sh80pw7";
        };
        doInstallCheck = false;
      }));
  yarl = (stdenv.lib.overrideDerivation pythonPackages.yarl
    (oldAttrs:
      { propagatedBuildInputs = [ multidict_3_1_3 ]; }));
  aiohttp = (stdenv.lib.overrideDerivation pythonPackages.aiohttp
    (oldAttrs:
      rec {
        propagatedBuildInputs = [ yarl multidict_3_1_3 ]
          ++ (with pythonPackages; [ async-timeout chardet ]);
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

  propagatedBuildInputs = [ yarl aiohttp aiohttp-cors multidict_3_1_3 ]
    ++ (with pythonPackages; [
      jinja2 psutil zipstream raven jsonschema typing
      prompt_toolkit
    ]);

  postPatch = ''
    sed -i 's/yarl>=0.11,<0.12/yarl/g' requirements.txt
  '';

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
