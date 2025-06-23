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
  csdreti,
  pycsdr,
  pycsdreti,
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
    version = "0.6.5";

    src = fetchFromGitHub {
      owner = "luarvique";
      repo = pname;
      rev = "870285269143048f850151346980942a12ccf24b";
      sha256 = "sha256-e0VEv9t4gVDxJEbDJm1aKSJeqlmhT/QimC3x4JJ6ke8=";
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
      homepage = "https://github.com/luarvique/owrx_connector";
      description = "Set of connectors that are used by OpenWebRX to interface with SDR hardware";
      license = licenses.gpl3Only;
      platforms = platforms.unix;
      teams = [ teams.c3d2 ];
    };
  };

in
buildPythonApplication rec {
  pname = "openwebrx";
  version = "1.2.82";
  format = "setuptools";
  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "openwebrx";
    rev = "0e13d5f290430d127cf0accd4e3c29e7435ee645";
    hash = "sha256-fwU1aMsjMMiq3zffFs8tksnR5bhTdeoeDQTaaLM0p7M=";
  };

  dependencies = [
    setuptools
    csdr
    csdreti
    pycsdr
    pycsdreti
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
    homepage = "https://github.com/luarvique/openwebrx";
    description = "Simple DSP library and command-line tool for Software Defined Radio";
    mainProgram = "openwebrx";
    license = licenses.gpl3Only;
    teams = [ teams.c3d2 ];
  };
}
