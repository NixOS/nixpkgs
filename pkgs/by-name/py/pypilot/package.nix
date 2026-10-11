{
  lib,
  python3Packages,
  fetchFromGitHub,
  swig,
  pkg-config,
  libgpiod,
}:

python3Packages.buildPythonApplication {
  pname = "pypilot";
  version = "0.70";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypilot";
    repo = "pypilot";
    rev = "33a12b06869ba21f854d9d2e1bca12c842421231";
    hash = "sha256-2EKTHBErpUsm1m7gHcQnQDGMvY22D9+14KEoXqAQO6M=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # Keep the control head idle when its LCD is disabled (driver "none"); without
  # this the screen subprocess busy-loops a core. Use the HTTP status code
  # (r.status_code) instead of the JSON body's 'statusCode' field in
  # request_access, and handle HTTP 404 (security disabled on the server) by
  # skipping token-based auth.
  patches = [
    ./pypilot-headless-lcd.patch
    ./pypilot-signalk-access.patch
  ];

  build-system = [ python3Packages.setuptools ];

  # swig is the binary tool here (the pyproject build-requirement of the same
  # name is the PyPI shim for it, dropped in postPatch).
  nativeBuildInputs = [
    pkg-config
    swig
  ];

  # libgpiod lets setup.py build the HAT display (ugfx) bindings with GPIO.
  buildInputs = [ libgpiod ];

  # Drop the git+https direct references so the deps resolve to Nix packages.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"RTIMULib @ git+https://github.com/seandepagnier/RTIMULib2@master#subdirectory=Linux/python",' '"RTIMULib",' \
      --replace-fail '"pypilot_data @ git+https://github.com/pypilot/pypilot_data@1df915910725d586cb846cdca42ee445c2709ff6"' '"pypilot_data"' \
      --replace-fail 'requires = ["setuptools>=64", "swig"]' 'requires = ["setuptools>=64"]'
  '';

  # The wheel build runs build_py before build_ext, so SWIG's generated .py
  # wrappers would be missing from the package. Generate the extensions (and
  # their wrappers) in-place first so build_py picks them up.
  preBuild = ''
    python setup.py build_ext --inplace
  '';

  dependencies = with python3Packages; [
    pyserial
    numpy
    scipy
    rtimulib2
    pypilot-data
    ujson
    pyudev
    inotify
    zeroconf
    requests
    websocket-client
    flask
    gevent-websocket
    python-socketio
    flask-socketio
    flask-babel
    libgpiod
    pillow
    wxpython
    pyopengl
    pyglet
    pywavefront
    importlib-metadata
  ];

  # Pi 4 GPU (V3D) exposes only desktop GL 3.1; pyglet (pypilot_calibration /
  # pypilot_scope 3D views) needs >= 3.3 and dies with "Could not create GL
  # context". Force the llvmpipe software renderer (GL 4.5). No-op for the
  # non-GL tools (daemon, web, hat).
  makeWrapperArgs = [
    "--set"
    "LIBGL_ALWAYS_SOFTWARE"
    "1"
  ];

  # Smoke-test that the SWIG extensions load.
  pythonImportsCheck = [
    "pypilot.linebuffer"
    "pypilot.arduino_servo.arduino_servo"
  ];

  meta = {
    description = "Free autopilot for sailboats, supporting SignalK and NMEA";
    homepage = "http://pypilot.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.darkone ];
    mainProgram = "pypilot";
    platforms = lib.platforms.linux;
  };
}
