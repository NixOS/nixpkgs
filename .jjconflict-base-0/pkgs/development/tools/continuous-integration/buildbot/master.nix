{
  lib,
  stdenv,
  buildPythonApplication,
  fetchFromGitHub,
  makeWrapper,
  # Tie withPlugins through the fixed point here, so it will receive an
  # overridden version properly
  buildbot,
  pythonOlder,
  python,
  twisted,
  jinja2,
  msgpack,
  zope-interface,
  sqlalchemy,
  alembic,
  python-dateutil,
  txaio,
  autobahn,
  pyjwt,
  pyyaml,
  treq,
  txrequests,
  pypugjs,
  boto3,
  moto,
  markdown,
  lz4,
  brotli,
  zstandard,
  setuptools-trial,
  buildbot-worker,
  buildbot-plugins,
  buildbot-pkg,
  parameterized,
  git,
  openssh,
  setuptools,
  croniter,
  importlib-resources,
  packaging,
  unidiff,
  glibcLocales,
  nixosTests,
}:

let
  withPlugins =
    plugins:
    buildPythonApplication {
      pname = "${buildbot.pname}-with-plugins";
      inherit (buildbot) version;
      format = "other";

      dontUnpack = true;
      dontBuild = true;
      doCheck = false;

      nativeBuildInputs = [
        makeWrapper
      ];

      propagatedBuildInputs = plugins ++ buildbot.propagatedBuildInputs;

      installPhase = ''
        makeWrapper ${buildbot}/bin/buildbot $out/bin/buildbot \
          --prefix PYTHONPATH : "${buildbot}/${python.sitePackages}:$PYTHONPATH"
        ln -sfv ${buildbot}/lib $out/lib
      '';

      passthru = buildbot.passthru // {
        withPlugins = morePlugins: withPlugins (morePlugins ++ plugins);
      };
    };
in
buildPythonApplication rec {
  pname = "buildbot";
  version = "4.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "buildbot";
    repo = "buildbot";
    rev = "v${version}";
    hash = "sha256-RPg4eXqpm/F1SSoB4MVo61DgZv/iE2R4VtCkUU69iA8=";
  };

  build-system = [
  ];

  pythonRelaxDeps = [
    "twisted"
  ];

  propagatedBuildInputs =
    [
      # core
      twisted
      jinja2
      msgpack
      zope-interface
      sqlalchemy
      alembic
      python-dateutil
      txaio
      autobahn
      pyjwt
      pyyaml
      setuptools
      croniter
      importlib-resources
      packaging
      unidiff
      treq
      brotli
      zstandard
    ]
    # tls
    ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [
    treq
    txrequests
    pypugjs
    boto3
    moto
    markdown
    lz4
    setuptools-trial
    buildbot-worker
    buildbot-pkg
    buildbot-plugins.www
    parameterized
    git
    openssh
    glibcLocales
  ];

  patches = [
    # This patch disables the test that tries to read /etc/os-release which
    # is not accessible in sandboxed builds.
    ./skip_test_linux_distro.patch
  ];

  postPatch = ''
    cd master
    touch buildbot/py.typed
    substituteInPlace buildbot/scripts/logwatcher.py --replace '/usr/bin/tail' "$(type -P tail)"
  '';

  # TimeoutErrors on slow machines -> aarch64
  doCheck = !stdenv.hostPlatform.isAarch64;

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
    export PATH="$out/bin:$PATH"
  '';

  passthru =
    {
      inherit withPlugins python;
      updateScript = ./update.sh;
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      tests = {
        inherit (nixosTests) buildbot;
      };
    };

  meta = with lib; {
    description = "Open-source continuous integration framework for automating software build, test, and release processes";
    homepage = "https://buildbot.net/";
    changelog = "https://github.com/buildbot/buildbot/releases/tag/v${version}";
    maintainers = teams.buildbot.members;
    license = licenses.gpl2Only;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
