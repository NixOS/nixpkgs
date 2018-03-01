{ pkgs, stdenv, python3 }:
let 
  packageOverrides = self: super:{
    ConfigArgParse = python3.pkgs.buildPythonPackage rec {
      src = python3.pkgs.fetchPypi {
        pname = "ConfigArgParse";
        version = "0.11.0";
        sha256 = "12dcl0wdsjxgphxadyz9bdzbvlwfaqgvba9s59ghajw4yqiyi2kc";
      };
      name = "configargparse-0.11.0";
    };
    aiohttp = python3.pkgs.buildPythonPackage rec {
      src = python3.pkgs.fetchPypi {
        pname = "aiohttp";
        version = "2.3.10";
        sha256 = "0r0955ar0yiwbp3war35z8zncs01nq84wdwk0v3s8f547dcadpca";
      };
      propagatedBuildInputs = [
        pythonPackages.async-timeout
        pythonPackages.chardet
        pythonPackages.multidict
        pythonPackages.yarl
        pythonPackages.idna-ssl
      ];
      doCheck = false; 
      name = "aiohttp-2.3.10";
    }; 
    ReParser = python3.pkgs.buildPythonPackage rec {
      src = python3.pkgs.fetchPypi {
        pname = "ReParser";
        version = "1.4.3";
        sha256 = "0nniqb69xr0fv7ydlmrr877wyyjb61nlayka7xr08vlxl9caz776";
      };
      name = "ReParser=1.4.3";
    };
    readlike = python3.pkgs.buildPythonPackage rec {
      src = python3.pkgs.fetchPypi {
        pname = "readlike";
        version = "0.1.2";
        sha256 = "1ck65ycw51f4xnbh4sg9axgbl81q3azpzvd5f2nvrv2fla9m8r08";
      };
      name = "readlike-0.1.2";
    };  
    MechanicalSoup = python3.pkgs.buildPythonPackage rec {
      src = pkgs.fetchurl {
        url = "mirror://pypi/M/MechanicalSoup/MechanicalSoup-0.6.0.zip";
        sha256 = "0ka3nximli7wcpy381grn6d75fnpf91050iwdcj4shf53z0m1fg2";
      };
      propagatedBuildInputs = [
        pythonPackages.requests
        pythonPackages.beautifulsoup4
      ];
      doCheck = false;
      name = "MechanicalSoup-0.6.0";
    }; 
  };
  pythonPackages = (python3.override { inherit packageOverrides;}).pkgs;

in python3.pkgs.buildPythonPackage rec {
  pname = "hangups";
  version = "0.4.4";
  name = "${pname}-${version}";

  propagatedBuildInputs = with pythonPackages; [ 
    ConfigArgParse 
    requests
    aiohttp
    ReParser
    appdirs
    urwid
    protobuf3_1
    readlike
    MechanicalSoup
  ];

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1sm8c9mfcdyhlb6k2cq1r4j3zpc4z47z7zs8yycmf45nmv0vg0h9";
  };
 
  doCheck = false;

  meta = with stdenv.lib; {
    description = "the first third-party instant messaging client for Google Hangouts";
    homepage = http://hangups.readthedocs.io/en/latest/;
    license = licenses.mit;
  };
}
