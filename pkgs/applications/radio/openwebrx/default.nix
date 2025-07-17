{
  stdenv,
  lib,
  buildPythonPackage,
  buildPythonApplication,
  fetchFromGitHub,
  pkg-config,
  cmake,
  setuptools,
  libsamplerate,
  fftwFloat,
  rtl-sdr,
  soapysdr-with-plugins,
  csdr,
  pycsdr,
  pydigiham,
  direwolf,
  sox,
  wsjtx,
  codecserver,
}:

let

  js8py = buildPythonPackage rec {
    pname = "js8py";
    version = "0.1.1";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "jketterl";
      repo = pname;
      rev = version;
      sha256 = "1j80zclg1cl5clqd00qqa16prz7cyc32bvxqz2mh540cirygq24w";
    };

    pythonImportsCheck = [
      "js8py"
      "test"
    ];

    meta = with lib; {
      homepage = "https://github.com/jketterl/js8py";
      description = "Library to decode the output of the js8 binary of JS8Call";
      license = licenses.gpl3Only;
      teams = [ teams.c3d2 ];
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
      libsamplerate
      fftwFloat
      csdr
      rtl-sdr
      soapysdr-with-plugins
    ];

    meta = with lib; {
      homepage = "https://github.com/jketterl/owrx_connector";
      description = "Set of connectors that are used by OpenWebRX to interface with SDR hardware";
      license = licenses.gpl3Only;
      platforms = platforms.unix;
      teams = [ teams.c3d2 ];
    };
  };

in
buildPythonApplication rec {
  pname = "openwebrx";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jketterl";
    repo = pname;
    rev = version;
    hash = "sha256-i3Znp5Sxs/KtJazHh2v9/2P+3cEocWB5wIpF7E4pK9s=";
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

  pythonImportsCheck = [
    "csdr"
    "owrx"
    "test"
  ];

  passthru = {
    inherit js8py owrx_connector;
  };

  meta = with lib; {
    homepage = "https://github.com/jketterl/openwebrx";
    description = "Simple DSP library and command-line tool for Software Defined Radio";
    mainProgram = "openwebrx";
    license = licenses.gpl3Only;
    teams = [ teams.c3d2 ];
  };
}
