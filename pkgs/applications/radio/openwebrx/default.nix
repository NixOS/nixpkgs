{ stdenv, lib, buildPythonPackage, buildPythonApplication, fetchFromGitHub
, pkg-config, cmake, setuptools
, rtl-sdr, soapysdr-with-plugins, csdr, direwolf
}:

let

  js8py = buildPythonPackage rec {
    pname = "js8py";
    version = "0.1.1";

    src = fetchFromGitHub {
      owner = "jketterl";
      repo = pname;
      rev = version;
      sha256 = "1j80zclg1cl5clqd00qqa16prz7cyc32bvxqz2mh540cirygq24w";
    };

    pythonImportsCheck = [ "js8py" "test" ];

    meta = with lib; {
      homepage = "https://github.com/jketterl/js8py";
      description = "A library to decode the output of the js8 binary of JS8Call";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ astro ];
    };
  };

  owrx_connector = stdenv.mkDerivation rec {
    pname = "owrx_connector";
    version = "0.5.0";

    src = fetchFromGitHub {
      owner = "jketterl";
      repo = pname;
      rev = version;
      sha256 = "0gz4nf2frrkx1mpjfjpz2j919fkc99g5lxd8lhva3lgqyisvf4yj";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      rtl-sdr
      soapysdr-with-plugins
    ];

    meta = with lib; {
      homepage = "https://github.com/jketterl/owrx_connector";
      description = "A set of connectors that are used by OpenWebRX to interface with SDR hardware";
      license = licenses.gpl3Only;
      platforms = platforms.unix;
      maintainers = with maintainers; [ astro ];
    };
  };

in
buildPythonApplication rec {
  pname = "openwebrx";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "jketterl";
    repo = pname;
    rev = version;
    sha256 = "0maxs07yx235xknvkbmhi2zds3vfkd66l6wz6kspz3jzl4c0v1f9";
  };

  propagatedBuildInputs = [
    setuptools
    csdr
    js8py
    soapysdr-with-plugins
    owrx_connector
    direwolf
  ];

  pythonImportsCheck = [ "csdr" "owrx" "test" ];

  passthru = {
    inherit js8py owrx_connector;
  };

  meta = with lib; {
    homepage = "https://github.com/jketterl/openwebrx";
    description = "A simple DSP library and command-line tool for Software Defined Radio";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro ];
  };
}
