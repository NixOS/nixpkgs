{
  lib,
  stdenv,
  fetchFromGitHub,
  writeScript,

  # javascript
  fetchYarnDeps,
  nodejs,
  webpack-cli,
  yarnBuildHook,
  yarnConfigHook,

  # python
  alembic,
  argcomplete,
  buildPythonPackage,
  colorlog,
  configupdater,
  connexion,
  cron-descriptor,
  croniter,
  cryptography,
  dill,
  flask-caching,
  flask-login,
  flask-session,
  fsspec,
  gitdb,
  gitpython,
  gunicorn,
  hatchling,
  lazy-object-proxy,
  linkify-it-py,
  lockfile,
  marshmallow-oneofschema,
  mdit-py-plugins,
  methodtools,
  opentelemetry-api,
  opentelemetry-exporter-otlp,
  packaging,
  pandas,
  pathspec,
  pendulum,
  pluggy,
  psutil,
  pytest-asyncio,
  pytestCheckHook,
  python,
  python-daemon,
  python-nvd3,
  python-slugify,
  rich-argparse,
  setproctitle,
  smmap,
  sqlalchemy,
  sqlalchemy-jsonfield,
  tabulate,
  tenacity,
  termcolor,
  tomli,
  trove-classifiers,
  universal-pathlib,

  # Extra airflow providers to enable
  enabledProviders ? [ ],
}:
let
  version = "2.10.5";

  airflow-src = fetchFromGitHub {
    owner = "apache";
    repo = "airflow";
    rev = "refs/tags/${version}";
    # Download using the git protocol rather than using tarballs, because the
    # GitHub archive tarballs don't appear to include tests
    forceFetchGit = true;
    hash = "sha256-q5/CM+puXE31+15F3yZmcrR74LrqHppdCDUqjLQXPfk=";
  };

  # airflow bundles a web interface, which is built using webpack by an undocumented shell script in airflow's source tree.
  # This replicates this shell script, fixing bugs in yarn.lock and package.json

  airflow-frontend = stdenv.mkDerivation rec {
    name = "airflow-frontend";

    src = "${airflow-src}/airflow/www";

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      hash = "sha256-hKgtMH4c8sPRDLPLVn+H8rmwc2Q6ei6U4er6fGuFn4I=";
    };

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      nodejs
      webpack-cli
    ];

    # The webpack license plugin tries to create /3rd-party-licenses when given the
    # original relative path
    postPatch = ''
      sed -i 's!../../../../3rd-party-licenses/LICENSES-ui.txt!/3rd-party-licenses/LICENSES-ui.txt!' webpack.config.js
    '';

    postBuild = ''
      find package.json yarn.lock static/css static/js -type f | sort | xargs md5sum > static/dist/sum.md5
    '';

    installPhase = ''
      mkdir -p $out/static/
      cp -r static/dist $out/static
    '';
  };

  requiredProviders = [
    "common_compat"
    "common_io"
    "common_sql"
    "fab"
    "ftp"
    "http"
    "imap"
    "smtp"
    "sqlite"
  ];

  # Import generated file with metadata for provider dependencies and imports.
  # Enable additional providers using enabledProviders above.
  providers = import ./providers.nix;
  getProviderPath = provider: lib.replaceStrings [ "_" ] [ "/" ] provider;
  getProviderDeps = provider: map (dep: python.pkgs.${dep}) providers.${provider}.deps;
  getProviderImports = provider: providers.${provider}.imports;
  providerImports = lib.concatMap getProviderImports enabledProviders;

  buildProvider =
    provider:
    let
      providerPath = getProviderPath provider;
    in
    python.pkgs.buildPythonPackage {
      pname = "apache-airflow-providers-${provider}";
      version = "unstable"; # will be extracted in the build phase
      pyproject = false; # providers packages don't have pyproject.toml nor setup.py

      src = airflow-src;

      propagatedBuildInputs = getProviderDeps provider;
      dependencies = [ packaging ];

      buildPhase = ''
        # extract version from the provider's __init__.py file
        if [ -f "airflow/providers/${providerPath}/__init__.py" ]; then
          version=$(grep -oP "(?<=__version__ = ')[^']+" "airflow/providers/${providerPath}/__init__.py" || echo "0.0.0")
          echo "Provider ${provider} version: $version"
        else
          echo "Error: __init__.py not found for provider ${provider} at path airflow/providers/${providerPath}"
          exit 1
        fi
      '';

      installPhase = ''
                      # create directory structure
                      mkdir -p $out/${python.sitePackages}/airflow/providers

                      # copy the provider directory
                      if [ -d "airflow/providers/${providerPath}" ]; then
                        mkdir -p $out/${python.sitePackages}/airflow/providers/$(dirname "${providerPath}")
                        cp -r airflow/providers/${providerPath} $out/${python.sitePackages}/airflow/providers/$(dirname "${providerPath}")

                        # create parent __init__.py files
                        touch $out/${python.sitePackages}/airflow/__init__.py
                        touch $out/${python.sitePackages}/airflow/providers/__init__.py

                        # create any needed intermediate __init__.py files for nested providers
                        providerDir=$(dirname "${providerPath}")
                        while [ "$providerDir" != "." ] && [ -n "$providerDir" ]; do
                          mkdir -p $out/${python.sitePackages}/airflow/providers/$providerDir
                          touch $out/${python.sitePackages}/airflow/providers/$providerDir/__init__.py
                          providerDir=$(dirname "$providerDir")
                        done

                        # create egg-info for package discovery
                        mkdir -p $out/${python.sitePackages}/apache_airflow_providers_${provider}.egg-info
                        cat > $out/${python.sitePackages}/apache_airflow_providers_${provider}.egg-info/PKG-INFO <<EOF
        Metadata-Version: 2.1
        Name: apache-airflow-providers-${lib.replaceStrings [ "_" ] [ "-" ] provider}
        Version: ${version}
        Summary: Apache Airflow Provider for ${provider}
        EOF
                      else
                        echo "Provider directory not found: airflow/providers/${providerPath}"
                        exit 1
                      fi
      '';
    };

  providerPackages = map buildProvider (requiredProviders ++ enabledProviders);

in
buildPythonPackage rec {
  pname = "apache-airflow";
  inherit version;
  src = airflow-src;
  pyproject = true;

  nativeBuildInputs = [ hatchling ];

  dependencies = [
    alembic
    argcomplete
    colorlog
    configupdater
    connexion
    cron-descriptor
    croniter
    cryptography
    dill
    flask-caching
    flask-login
    flask-session
    fsspec
    gitdb
    gitpython
    gunicorn
    lazy-object-proxy
    linkify-it-py
    lockfile
    mdit-py-plugins
    methodtools
    opentelemetry-api
    opentelemetry-exporter-otlp
    packaging
    pandas
    pathspec
    pendulum
    pluggy
    psutil
    python-daemon
    python-nvd3
    python-slugify
    rich-argparse
    setproctitle
    smmap
    sqlalchemy
    sqlalchemy-jsonfield
    tabulate
    tenacity
    termcolor
    tomli
    trove-classifiers
    universal-pathlib
  ]
  ++ providerPackages;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    marshmallow-oneofschema
  ];

  checkPhase = ''
    export PYTEST_ADDOPTS="--asyncio_default_fixture_loop_scope=cache"
  '';

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.27.0" "hatchling" \
      --replace-fail "\"/airflow/providers/\"," ""
  '';

  pythonRelaxDeps = [
    "apache-airflow-providers-fab" # fab provider package has wrong version
    "colorlog"
    "pathspec"
  ];

  # allow for gunicorn processes to have access to Python packages
  makeWrapperArgs = [
    "--prefix PYTHONPATH : $PYTHONPATH"
  ];

  postInstall = ''
    cp -rv ${airflow-frontend}/static/dist $out/${python.sitePackages}/airflow/www/static
    # Needed for pythonImportsCheck below
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "airflow"
  ]
  ++ providerImports;

  preCheck = ''
    export AIRFLOW_HOME=$HOME
    export AIRFLOW__CORE__UNIT_TEST_MODE=True
    export AIRFLOW_DB="$HOME/airflow.db"
    export PATH=$PATH:$out/bin
  '';

  enabledTestPaths = [
    "tests/core/test_core.py"
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    "bash_operator_kill" # psutil.AccessDenied
  ];

  # Updates yarn.lock and package.json
  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts curl pcre "python3.withPackages (ps: with ps; [ pyyaml ])" yarn2nix

    set -euo pipefail

    # Get new version
    new_version="$(curl -s https://airflow.apache.org/docs/apache-airflow/stable/release_notes.html |
      pcregrep -o1 'Airflow ([0-9.]+).' | head -1)"
    update-source-version ${pname} "$new_version"

    # Update frontend
    cd ./pkgs/servers/apache-airflow
    curl -O https://raw.githubusercontent.com/apache/airflow/$new_version/airflow/www/yarn.lock
    curl -O https://raw.githubusercontent.com/apache/airflow/$new_version/airflow/www/package.json
    yarn2nix > yarn.nix

    # update provider dependencies
    ./update-providers.py
  '';

  # Note on testing the web UI:
  # You can (manually) test the web UI as follows:
  #
  #   nix shell .#apache-airflow
  #   airflow version
  #   airflow db reset  # WARNING: this will wipe any existing db state you might have!
  #   airflow standalone
  #
  # Then navigate to the localhost URL using the credentials printed, try
  # triggering the 'example_bash_operator' DAG and see if it reports success.

  meta = {
    description = "Programmatically author, schedule and monitor data pipelines";
    homepage = "https://airflow.apache.org/";
    changelog = "https://airflow.apache.org/docs/apache-airflow/${version}/release_notes.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      taranarmo
    ];
  };
}
