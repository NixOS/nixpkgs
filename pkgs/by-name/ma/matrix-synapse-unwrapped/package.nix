{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  openssl,
  libiconv,
  cargo,
  rustPlatform,
  rustc,
  nixosTests,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "matrix-synapse";
  version = "1.139.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "synapse";
    rev = "v${version}";
    hash = "sha256-L9oTTdGF//srC3sDrI8aNMjc9lOkof+J2VLFy091HBo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-PUwSg//1xAMyv0HOMt4YFR680fQ+7YAcSJ0vmlPyCzQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools_rust>=1.3,<=1.11.1" "setuptools_rust<=1.12,>=1.3"
  '';

  build-system = with python3Packages; [
    poetry-core
    setuptools-rust
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  pythonRemoveDeps = [ "setuptools_rust" ];

  dependencies =
    with python3Packages;
    [
      attrs
      bcrypt
      bleach
      canonicaljson
      cryptography
      ijson
      immutabledict
      jinja2
      jsonschema
      matrix-common
      msgpack
      python-multipart
      netaddr
      packaging
      phonenumbers
      pillow
      prometheus-client
      pyasn1
      pyasn1-modules
      pydantic
      pymacaroons
      pyopenssl
      pyyaml
      service-identity
      signedjson
      sortedcontainers
      treq
      twisted
      typing-extensions
      unpaddedbase64
    ]
    ++ twisted.optional-dependencies.tls;

  optional-dependencies = with python3Packages; {
    postgres =
      if isPyPy then
        [
          psycopg2cffi
        ]
      else
        [
          psycopg2
        ];
    saml2 = [
      pysaml2
    ];
    oidc = [
      authlib
    ];
    systemd = [
      systemd
    ];
    url-preview = [
      lxml
    ];
    sentry = [
      sentry-sdk
    ];
    jwt = [
      authlib
    ];
    redis = [
      hiredis
      txredisapi
    ];
    cache-memory = [
      pympler
    ];
  };

  nativeCheckInputs = [
    openssl
  ]
  ++ (with python3Packages; [
    mock
    parameterized
  ])
  ++ lib.filter (pkg: !pkg.meta.broken) (lib.flatten (lib.attrValues optional-dependencies));

  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    runHook preCheck

    # remove src module, so tests use the installed module instead
    rm -rf ./synapse

    # high parallelisem makes test suite unstable
    # upstream uses 2 cores but 4 seems to be also stable
    # https://github.com/element-hq/synapse/blob/develop/.github/workflows/latest_deps.yml#L103
    if (( $NIX_BUILD_CORES > 4)); then
      NIX_BUILD_CORES=4
    fi

    PYTHONPATH=".:$PYTHONPATH" ${python3Packages.python.interpreter} -m twisted.trial -j $NIX_BUILD_CORES tests

    runHook postCheck
  '';

  passthru = {
    tests = { inherit (nixosTests) matrix-synapse matrix-synapse-workers; };
    plugins = python3Packages.callPackage ./plugins { };
    inherit (python3Packages) python;
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://matrix.org";
    changelog = "https://github.com/element-hq/synapse/releases/tag/v${version}";
    description = "Matrix reference homeserver";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ sumnerevans ];
    teams = [ lib.teams.matrix ];
    platforms = lib.platforms.linux;
  };
}
