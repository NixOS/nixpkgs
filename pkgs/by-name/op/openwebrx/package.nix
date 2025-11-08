{
  stdenv,
  lib,
  python3Packages,
  fetchFromGitHub,
  pkg-config,
  cmake,
  libsamplerate,
  fftwFloat,
  rtl-sdr,
  soapysdr-with-plugins,
  csdr,
  direwolf,
  sox,
  wsjtx,
  codecserver,
  versionCheckHook,
}:

let

  js8py = python3Packages.buildPythonPackage rec {
    pname = "js8py";
    version = "0.1.1";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "jketterl";
      repo = "js8py";
      tag = version;
      hash = "sha256-nAj8fI4MkAKr+LjvJQbz7Px8TVAYA9AwZYWy8Cj7AMk=";
    };

    pythonImportsCheck = [
      "js8py"
      "test"
    ];

    meta = {
      homepage = "https://github.com/jketterl/js8py";
      description = "Library to decode the output of the js8 binary of JS8Call";
      license = lib.licenses.gpl3Only;
      teams = with lib.teams; [ c3d2 ];
    };
  };

  owrx_connector = stdenv.mkDerivation rec {
    pname = "owrx_connector";
    version = "0.6.0";

    src = fetchFromGitHub {
      owner = "jketterl";
      repo = "owrx_connector";
      tag = version;
      hash = "sha256-1H0TJ8QN3b6Lof5TWvyokhCeN+dN7ITwzRvEo2X8OWc=";
    };

    postPatch = ''
      substituteInPlace CMakeLists.txt --replace-fail \
        "cmake_minimum_required (VERSION 3.0)" \
        "cmake_minimum_required (VERSION 3.10)"
    '';

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

    nativeInstallCheckInputs = [ versionCheckHook ];
    versionCheckProgram = "${placeholder "out"}/bin/rtl_connector";
    doInstallCheck = true;

    meta = {
      homepage = "https://github.com/jketterl/owrx_connector";
      description = "Set of connectors that are used by OpenWebRX to interface with SDR hardware";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.unix;
      teams = with lib.teams; [ c3d2 ];
    };
  };

in
python3Packages.buildPythonApplication rec {
  pname = "openwebrx";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jketterl";
    repo = "openwebrx";
    tag = version;
    hash = "sha256-i3Znp5Sxs/KtJazHh2v9/2P+3cEocWB5wIpF7E4pK9s=";
  };

  dependencies =
    with python3Packages;
    [
      setuptools
      csdr
      pycsdr
      pydigiham
    ]
    ++ [
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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    inherit js8py owrx_connector;
  };

  meta = {
    homepage = "https://github.com/jketterl/openwebrx";
    description = "Simple DSP library and command-line tool for Software Defined Radio";
    mainProgram = "openwebrx";
    license = lib.licenses.gpl3Only;
    teams = with lib.teams; [ c3d2 ];
  };
}
