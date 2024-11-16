{ lib
, bubblewrap
, cacert
, fetchFromGitLab
, git
, openmw
, jre
, perl
, python3Packages
, rustPlatform
, fontconfig
, freetype
, libX11
, harfbuzz
, fribidi
}:

let
  version = "2.8.0";

  src = fetchFromGitLab {
    owner = "portmod";
    repo = "Portmod";
    rev = "v${version}";
    hash = "sha256-SV0nwUA72vBnaelbErmrSERCWSnZjKUv9LSH4aT8klA=";
  };

  portmod-rust = rustPlatform.buildRustPackage {
    inherit src version;
    pname = "portmod-rust";

    cargoHash = "sha256-+JFfbXAjWo8Cx1W7tcPCEBh7qbINjOZtsTjjM8pYevQ=";

    nativeBuildInputs = [
      python3Packages.python
    ];

    doCheck = false;
  };

  bin-programs = [
    bubblewrap
    git
    python3Packages.virtualenv
    openmw
    jre # to run tr-patcher
    perl # to run tes3cmd
  ];

  # Portmod fetch some binaries by itself, but seems to neglect a few common libraries (at least for ImageMagick)
  extra-libs = [
    fontconfig
    freetype
    libX11
    harfbuzz
    fribidi
  ];
in
python3Packages.buildPythonApplication {
  inherit src version;

  pname = "portmod";
  format = "pyproject";

  # build the rust library independantly
  prePatch = ''
    substituteInPlace setup.py \
      --replace "from setuptools_rust import Binding, RustExtension, Strip" "" \
      --replace "RustExtension(\"portmodlib.portmod\", binding=Binding.PyO3, strip=Strip.Debug)" ""

    substituteInPlace pyproject.toml \
      --replace '"setuptools-rust"' ""
  '';

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    setuptools-scm
    setuptools
    requests
    chardet
    colorama
    deprecated
    restrictedpython
    appdirs
    gitpython
    progressbar2
    python-sat
    redbaron
    patool
    packaging
    fasteners
    distutils
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ] ++ bin-programs;

  preCheck = ''
    cp ${portmod-rust}/lib/libportmod.so portmodlib/portmod.so
    export HOME=$(mktemp -d)
  '';

  # some test require network access
  disabledTests = [
    "test_masters_esp"
    "test_logging"
    "test_execute_network_permissions"
    "test_execute_permissions_bleed"
    "test_git"
    "test_sync"
    "test_manifest"
    "test_add_repo"
    "test_init_prefix_interactive"
    "test_scan_sources"
    "test_unpack"
  ];

  # for some reason, installPhase doesn't copy the compiled binary
  postInstall = ''
    cp ${portmod-rust}/lib/libportmod.so $out/${python3Packages.python.sitePackages}/portmodlib/portmod.so

    makeWrapperArgs+=("--prefix" "GIT_SSL_CAINFO" ":" "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      "--prefix" "PATH" ":" "${lib.makeBinPath bin-programs }" \
      "--prefix" "LD_LIBRARY_PATH" ":" "${lib.makeLibraryPath extra-libs }")
  '';

  meta = with lib; {
    description = "mod manager for openMW based on portage";
    homepage = "https://gitlab.com/portmod/portmod";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ marius851000 ];
  };
}
