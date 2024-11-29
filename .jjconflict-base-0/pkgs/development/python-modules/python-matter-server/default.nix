{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  stdenvNoCC,
  substituteAll,

  # build
  setuptools,

  # propagates
  aiohttp,
  aiorun,
  async-timeout,
  coloredlogs,
  orjson,
  home-assistant-chip-clusters,

  # optionals
  cryptography,
  home-assistant-chip-core,
  zeroconf,

  # tests
  aioresponses,
  python,
  pytest,
  pytest-aiohttp,
  pytestCheckHook,
}:

let
  paaCerts = stdenvNoCC.mkDerivation rec {
    pname = "matter-server-paa-certificates";
    version = "1.3.0.0";

    src = fetchFromGitHub {
      owner = "project-chip";
      repo = "connectedhomeip";
      rev = "refs/tags/v${version}";
      hash = "sha256-5MI6r0KhSTzolesTQ8YWeoko64jFu4jHfO5KOOKpV0A=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp $src/credentials/development/paa-root-certs/* $out/

      runHook postInstall
    '';
  };
in

buildPythonPackage rec {
  pname = "python-matter-server";
  version = "6.6.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "python-matter-server";
    rev = "refs/tags/${version}";
    hash = "sha256-g+97a/X0FSapMLfdW6iNf1akkHGLqCmHYimQU/M6loo=";
  };

  patches = [
    (substituteAll {
      src = ./link-paa-root-certs.patch;
      paacerts = paaCerts;
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace '--cov' ""
  '';

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [ "home-assistant-chip-clusters" ];

  dependencies = [
    aiohttp
    aiorun
    async-timeout
    coloredlogs
    orjson
    home-assistant-chip-clusters
  ];

  optional-dependencies = {
    server = [
      cryptography
      home-assistant-chip-core
      zeroconf
    ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  preCheck =
    let
      pythonEnv = python.withPackages (_: dependencies ++ nativeCheckInputs ++ [ pytest ]);
    in
    ''
      export PYTHONPATH=${pythonEnv}/${python.sitePackages}
    '';

  meta = with lib; {
    changelog = "https://github.com/home-assistant-libs/python-matter-server/releases/tag/${version}";
    description = "Python server to interact with Matter";
    mainProgram = "matter-server";
    homepage = "https://github.com/home-assistant-libs/python-matter-server";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
