{stdenv, python3, lib}:

let 
  python = python3.override {
    packageOverrides = self: super: {
      MechanicalSoup = super.MechanicalSoup.overridePythonAttrs(oldAttrs: rec {
        version = "0.6.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "e2b950c11fc5414d246b3c82024272d7ba729ab1f90534fc65fc445a63b7434d";
          extension = "zip";
        };
      });
      ConfigArgParse = super.ConfigArgParse.overridePythonAttrs(oldAttrs: rec {
        version = "0.11.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "6c8ae823f6844b055f2a3aa9b51f568ed3bd7e5be9fba63abcaf4bdd38a0ac89";
        };
      });
    };
  };
in with python.pkgs; buildPythonApplication rec {
  pname = "hangups";
  version = "0.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c3e24a429b1000985d2c51300162b9e04ab3c7150d477e5760c5e916d2db3d4";
  };
  
  propagatedBuildInputs = 
    [ urwid 
      readlike 
      async-timeout 
      MechanicalSoup
      aiohttp
      appdirs
      ReParser
      protobuf3_1
      ConfigArgParse
    ];

  # No tests included in Pypi package
  doCheck = false;
  
  meta = {
    description = "The first third-party instant messaging client for Google Hangouts";
    homepage = https://github.com/tdryer/hangups; 
    license = stdenv.lib.licenses.mit;
    maintainers = with lib.maintainers; [ aswan89 ];   
  };
}
