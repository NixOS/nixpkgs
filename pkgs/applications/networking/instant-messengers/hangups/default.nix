{ pkgs, stdenv, python3 }:
let 
  packageOverrides = self: super:{

    ConfigArgParse = super.ConfigArgParse.overridePythonAttrs (oldAttrs: rec {
      version = "0.11.0";
      src = oldAttrs.src.override {
        inherit version; 
        sha256 = "12dcl0wdsjxgphxadyz9bdzbvlwfaqgvba9s59ghajw4yqiyi2kc";
      };
    });

    aiohttp = super.aiohttp.overridePythonAttrs (oldAttrs: rec {
      version = "2.3.10";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "0r0955ar0yiwbp3war35z8zncs01nq84wdwk0v3s8f547dcadpca";
      };
    }); 

    MechanicalSoup = super.MechanicalSoup.overridePythonAttrs (oldAttrs: rec {
      version = "0.6.0";
      src = pkgs.fetchurl {
        url = "mirror://pypi/M/MechanicalSoup/MechanicalSoup-0.6.0.zip";
        sha256 = "0ka3nximli7wcpy381grn6d75fnpf91050iwdcj4shf53z0m1fg2";
      };
    }); 
  };
  pythonPackages = (python3.override { inherit packageOverrides;}).pkgs;

in python3.pkgs.buildPythonApplication rec {
  pname = "hangups";
  version = "0.4.4";

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

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "1sm8c9mfcdyhlb6k2cq1r4j3zpc4z47z7zs8yycmf45nmv0vg0h9";
  };
 
  doCheck = true;

  meta = with stdenv.lib; {
    description = "The first third-party instant messaging client for Google Hangouts";
    homepage = http://github.com/tdryer/hangups;
    license = licenses.mit;
  };
}
