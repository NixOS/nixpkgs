{ stdenv, lib, buildPythonPackage, buildPythonApplication, fetchFromGitHub
, pkg-config, cmake, setuptools
, libsamplerate, fftwFloat
, rtl-sdr, soapysdr-with-plugins, csdr, pycsdr, pydigiham, direwolf, sox, wsjtx, codecserver
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
      maintainers = teams.c3d2.members;
    };
  };

  owrx_connector = stdenv.mkDerivation rec {
    pname = "owrx_connector";
    version = "0.6.0";

    src = fetchFromGitHub {
      owner = "jketterl";
      repo = pname;
      rev = version;
      sha256 = "sha256-1H0TJ8QN3b6Lof5TWvyokhCeN+dN7ITwzRvEo2X8OWc=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      libsamplerate fftwFloat
      csdr
      rtl-sdr
      soapysdr-with-plugins
    ];

    meta = with lib; {
      homepage = "https://github.com/jketterl/owrx_connector";
      description = "A set of connectors that are used by OpenWebRX to interface with SDR hardware";
      license = licenses.gpl3Only;
      platforms = platforms.unix;
      maintainers = teams.c3d2.members;
    };
  };

in
buildPythonApplication rec {
  pname = "openwebrx";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jketterl";
    repo = pname;
    rev = version;
    sha256 = "sha256-7gcgwa9vQT2u8PQusuXKted2Hk0K+Zk6ornSG1K/D4c=";
  };

  propagatedBuildInputs = [
    setuptools
    csdr
    pycsdr
    pydigiham
    js8py
    soapysdr-with-plugins
    owrx_connector
    direwolf
    sox
    wsjtx
    codecserver
  ];

  pythonImportsCheck = [ "csdr" "owrx" "test" ];

  passthru = {
    inherit js8py owrx_connector;
  };

  meta = with lib; {
    homepage = "https://github.com/jketterl/openwebrx";
    description = "A simple DSP library and command-line tool for Software Defined Radio";
    license = licenses.gpl3Only;
    maintainers = teams.c3d2.members;
  };
}
