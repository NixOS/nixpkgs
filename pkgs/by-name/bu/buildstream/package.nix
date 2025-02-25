{
  python312Packages,
  fetchPypi,
  fetchFromGitLab,
  lzip,
  patch,
  bubblewrap,
  fuse3,
  lib,
  pdm,
  buildbox,
  withPlugins ? true,
  withCommunityPlugins ? false,
}:
let
  # FIXME: Lock to Python 3.12 until PR
  # (https://github.com/apache/buildstream/pull/1993) is included in a new
  # BuildStream release.
  inherit (python312Packages) buildPythonApplication buildPythonPackage;
  pyroaring = buildPythonPackage rec {
    pname = "pyroaring";
    version = "1.0.0";
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-rzdDTTuZHOXBZ/AZLTVnEoZoZk9MTxsS3b6Be4BETI0=";
    };
    doCheck = false;
    propagatedBuildInputs = with python312Packages; [ cython ];
    nativeBuildInputs = with python312Packages; [
      pdm-pep517
      setuptools-scm
      pip
    ];
    meta = {
      platforms = lib.platforms.linux;
    };
  };
  # FIXME: Split into separate derivation.
  buildstream-plugins = buildPythonPackage rec {
    pname = "buildstream-plugins";
    version = "2.4.0";
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-fvWk7QomDhq93xwRJKfr8e1+mddZghccGm44fytD1lw=";
    };
    doCheck = false;
    meta = {
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ shymega ];
    };
  };
  # FIXME: Split into separate derivation.
  buildstream-plugins-community = buildPythonPackage rec {
    pname = "buildstream-plugins-community";
    version = "2.0.1";
    src = fetchFromGitLab {
      owner = "BuildStream";
      repo = pname;
      tag = version;
      hash = "sha256-v39En61py9X9ZWtT6qw+3GYBWxWKlTA/ytE8kMWAP6U=";
    };
    doCheck = false;
    meta = {
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ shymega ];
    };
  };

in
buildPythonApplication rec {
  pname = "buildstream";
  version = "2.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dj25ELy/79ouN8zRHvoSxX2XNdOgN5BNdbEiditIAro=";
  };

  build-system = with python312Packages; [ setuptools ];

  dependencies = with python312Packages; [
    click
    dulwich
    grpcio
    jinja2
    markupsafe
    packaging
    pluginbase
    protobuf
    psutil
    pyroaring
    requests
    ruamel-yaml
    ruamel-yaml-clib
    tomlkit
    ujson
  ];

  propagatedBuildInputs =
    [
      buildbox
      fuse3
      lzip
      patch
      python312Packages.cython
    ]
    ++ lib.optional withPlugins buildstream-plugins
    ++ lib.optional withCommunityPlugins buildstream-plugins-community;

  nativeBuildInputs = with python312Packages; [
    bubblewrap
    pdm-pep517
    setuptools-scm
  ];

  doCheck = false;

  meta = {
    description = "BuildStream is a powerful software integration tool that allows developers to automate the integration of software components including operating systems, and to streamline the software development and production process.";
    downloadPage = "https://buildstream.build/install.html";
    homepage = "https://buildstream.build/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "bst";
    maintainers = with lib.maintainers; [ shymega ];
  };
}
