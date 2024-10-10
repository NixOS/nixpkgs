{
  stdenv,
  lib,
  python3Packages,
  fetchFromGitHub,
  pkg-config,
  cmake,
  ninja,
  libsamplerate,
  fftwFloat,
  rtl-sdr,
  soapysdr-with-plugins,
  direwolf,
  sox,
  wsjtx,
  codecserver,
  openwebrx,
  dablin,
  dump1090,
  hamlib,
  imagemagick,
  multimon-ng,
  nrsc5,
  rtl_433,
}:
let
  inherit (python3Packages)
    buildPythonPackage
    buildPythonApplication
    pydigiham
    setuptools
    python
    ;

  inherit (openwebrx.passthru) js8py;

  csdr-eti = stdenv.mkDerivation rec {
    pname = "csdr-eti";
    version = "0.0.11";

    src = fetchFromGitHub {
      owner = "luarvique";
      repo = "csdr-eti";
      rev = version;
      hash = "sha256-jft4zi1mLU6zZ+2gsym/3Xu8zkKL0MeoztcyMPM0RYI=";
    };

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
    ];

    propagatedBuildInputs = [
      fftwFloat
      libsamplerate
    ];
    buildInputs = [ csdr ];

    hardeningDisable = lib.optional stdenv.isAarch64 "format";

    meta = with lib; {
      homepage = "https://github.com/jketterl/csdr";
      description = "Simple DSP library and command-line tool for Software Defined Radio";
      license = licenses.gpl3Only;
      platforms = platforms.unix;
      broken = stdenv.isDarwin;
      maintainers = teams.c3d2.members;
    };
  };

  csdr = stdenv.mkDerivation rec {
    pname = "csdr";
    version = "0.18.23";

    src = fetchFromGitHub {
      owner = "luarvique";
      repo = "csdr";
      rev = version;
      hash = "sha256-Q7g1OqfpAP6u78zyHjLP2ASGYKNKCAVv8cgGwytZ+cE=";
    };

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
    ];

    propagatedBuildInputs = [
      fftwFloat
      libsamplerate
    ];

    hardeningDisable = lib.optional stdenv.isAarch64 "format";

    postFixup = ''
      substituteInPlace "$out"/lib/pkgconfig/csdr.pc \
        --replace-fail '=''${prefix}//' '=/' \
        --replace-fail '=''${exec_prefix}//' '=/'
    '';

    meta = with lib; {
      homepage = "https://github.com/jketterl/csdr";
      description = "Simple DSP library and command-line tool for Software Defined Radio";
      license = licenses.gpl3Only;
      platforms = platforms.unix;
      broken = stdenv.isDarwin;
      maintainers = teams.c3d2.members;
    };
  };

  pycsdr-eti = buildPythonPackage rec {
    pname = "pycsdr-eti";
    version = "0.0.11";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "luarvique";
      repo = "pycsdr-eti";
      rev = version;
      hash = "sha256-pjY5sxHvuDTUDxpdhWk8U7ibwxHznyywEqj1btAyXBE=";
    };

    postPatch = ''
      substituteInPlace setup.py \
        --replace-fail ', "fftw3"' ""
    '';

    build-system = [ setuptools ];
    dependencies = [ pycsdr ];
    buildInputs = [
      csdr-eti
      csdr
    ];
    NIX_CFLAGS_COMPILE = [ "-I${pycsdr}/include/${python.libPrefix}" ];

    # has no tests
    doCheck = false;
    pythonImportsCheck = [ "csdreti" ];

    meta = {
      homepage = "https://github.com/jketterl/pycsdr-eti";
      description = "Bindings for csdr-eti";
      license = lib.licenses.gpl3Only;
      maintainers = lib.teams.c3d2.members;
    };
  };

  pycsdr = buildPythonPackage rec {
    pname = "pycsdr";
    version = "0.18.23";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "luarvique";
      repo = "pycsdr";
      rev = version;
      hash = "sha256-NjRBC7bhq2bMlRI0Q8bcGcneD/HlAO6l/0As3/lk4e8=";
    };

    build-system = [ setuptools ];

    buildInputs = [ csdr ];

    # has no tests
    doCheck = false;
    pythonImportsCheck = [ "pycsdr" ];

    meta = {
      homepage = "https://github.com/jketterl/pycsdr";
      description = "Bindings for the csdr library";
      license = lib.licenses.gpl3Only;
      maintainers = lib.teams.c3d2.members;
    };
  };

  owrx_connector = stdenv.mkDerivation rec {
    pname = "owrx-connector";
    version = "0.6.5";

    src = fetchFromGitHub {
      owner = "luarvique";
      repo = "owrx_connector";
      rev = version;
      sha256 = "sha256-e0VEv9t4gVDxJEbDJm1aKSJeqlmhT/QimC3x4JJ6ke8=";
    };

    nativeBuildInputs = [
      cmake
      ninja
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
      maintainers = teams.c3d2.members;
    };
  };
in
buildPythonApplication rec {
  pname = "openwebrxplus";
  version = "1.2.70";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "openwebrx";
    rev = version;
    sha256 = "sha256-17Ug3xZ2tUMvwn3SUZqz8Y1Dd7UQrEsa5YQ7XV+FId0=";
  };

  build-dependencies = [ setuptools ];

  dependencies = [
    dablin
    direwolf
    dump1090
    hamlib
    imagemagick
    multimon-ng
    nrsc5
    rtl_433
    wsjtx
    setuptools
    pycsdr
    pycsdr-eti
    pydigiham
    js8py
    owrx_connector
    soapysdr-with-plugins
  ];

  buildInputs = [
    direwolf
    sox
    wsjtx
    codecserver
  ];

  pythonImportsCheck = [
    "pycsdr"
    "owrx"
    "test"
  ];

  passthru = {
    inherit
      js8py
      owrx_connector
      pycsdr
      csdr
      ;
  };

  meta = with lib; {
    homepage = "https://github.com/luarvique/openwebrx";
    description = "Simple DSP library and command-line tool for Software Defined Radio";
    mainProgram = "openwebrx";
    license = licenses.gpl3Only;
    maintainers =
      with maintainers;
      [
        arcnmx
        kittywitch
      ]
      ++ teams.c3d2.members;
  };
}
