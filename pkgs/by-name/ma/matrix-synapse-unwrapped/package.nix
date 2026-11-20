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
  version = "1.164.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "synapse";
    rev = "v${version}";
    hash = "sha256-66wozKGD2/C2zypRWCw3NyiSC0K1RB7XqzSV84b5l54=";
  };

  patches = [
    # fix compatibility with authlib authlib 1.7+
    # https://github.com/element-hq/synapse/pull/20330
    ./authlib.patch
  ];

  postPatch = ''
    # the timeout for some tests is too tight, causing the build to fail
    # if the builder is too contested. the earliest example of these
    # intermittend failures i could find was
    # https://hydra.nixos.org/build/349689621/step/1/log/tail
    # See: https://github.com/element-hq/synapse/pull/20517
    substituteInPlace tests/server.py tests/unittest.py \
      --replace-fail "loop_count > 100" "loop_count > 5000"
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-zs6nvOvCh45GDyEIsqMn9PwqibjEx2f91sXqqmQVZRQ=";
  };

  build-system =
    with python3Packages;
    [
      poetry-core
      setuptools-rust
    ]
    ++ [
      rustPlatform.maturinBuildHook
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
      pyparsing
      pyrsistent
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
      systemd-python
    ];
    url-preview = [
      beautifulsoup4
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

  pythonRemoveDeps = [
    # part of saml2 extra but unused at runtime
    "lxml-stubs"
  ];

  nativeCheckInputs = [
    openssl
  ]
  ++ (with python3Packages; [
    mock
    parameterized
  ])
  ++ lib.filter (pkg: !pkg.meta.broken) (lib.concatAttrValues optional-dependencies);

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
    tests = { inherit (nixosTests) matrix-synapse; };
    plugins = python3Packages.callPackage ./plugins { };
    inherit (python3Packages) python;
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://matrix.org";
    changelog = "https://github.com/element-hq/synapse/blob/v${version}/CHANGES.md";
    description = "Matrix reference homeserver";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ sumnerevans ];
    teams = [ lib.teams.matrix ];
    platforms = lib.platforms.linux;
  };
}
