# Gel database server (geldata/gel), built without the in-tree
# PostgreSQL: the Gel-tracked fork comes from the gel-postgresql package
# and is wired via EDGEDB_BUILD_PG_CONFIG (setup.py honors the env
# fallback when --pg-config is absent). Only the build_py / build_ext
# (Cython + Rust) / build_parsers / build_metadata subcommands run;
# build_postgres and build_ui are intentionally never invoked here.
{
  lib,
  fetchFromGitHub,
  python312Packages,
  rustPlatform,
  pkg-config,
  openssl,
  gel-postgresql,
  gel-server,
  testers,
}:
python312Packages.buildPythonApplication rec {
  pname = "gel-server";
  version = "7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geldata";
    repo = "gel";
    rev = "e0ef1b92dec1910bb40585c7a818944c4717ec29";
    hash = "sha256-1VmaVEwFpt2ZpAQzH/9ravn4D51gyEGBeeDBu1pyHwk=";
  };

  py-pgproto = fetchFromGitHub {
    owner = "MagicStack";
    repo = "py-pgproto";
    rev = "9f415b2c834df119422c011e5163e21064bff6ad";
    hash = "sha256-ZVw2+FM0R7MeUTKh8u0+p8puERWrRmWKtvDbtg5+e4A=";
  };

  libpg-query = fetchFromGitHub {
    owner = "geldata";
    repo = "libpg_query";
    rev = "e6028fb253c3ea75aea5c67bd3178538d8fde049";
    hash = "sha256-IMT3R6HEAVyCXElpH5p4Es67ZYBXDy6XhmMVt+wrVwc=";
  };

  postUnpack = ''
    # Assemble the submodules setup.py expects, without the postgres/
    # submodule (built separately as gel-postgresql).
    cp -r ${py-pgproto} source/edb/server/pgproto
    chmod -R u+w source/edb/server/pgproto
    cp -r ${libpg-query} source/edb/pgsql/parser/libpg_query
    chmod -R u+w source/edb/pgsql/parser/libpg_query
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}-cargo-deps";
    hash = "sha256-6Ll2PjKEeU2zxxq3QVaYbj/VmP5xlyx4S/T42OeZE64=";
  };

  build-system = with python312Packages; [
    setuptools
    cython
    setuptools-rust
    wheel
    packaging
    parsing
    gel
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    openssl
  ];

  dependencies = with python312Packages; [
    gel
    httptools
    immutables
    parsing
    uvloop
    click
    cryptography
    graphql-core
    psutil
    setproctitle
    webauthn
    argon2-cffi
    aiosmtplib
    tiktoken
    mistral-common
    calver
  ];

  # Bypass the default `build` (which would build in-tree postgres, the UI,
  # and git-clone pgvector): run only the server subcommands, then install
  # from the build tree. pg_config points at the Gel-tracked fork.
  __structuredAttrs = true;

  EDGEDB_BUILD_PG_CONFIG = "${gel-postgresql}/bin/pg_config";

  buildPhase = ''
    runHook preBuild
    python setup.py build_py build_ext build_parsers build_metadata
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    python setup.py install --skip-build --prefix=$out
    runHook postInstall
  '';

  pythonImportsCheck = ["edb"];

  passthru.tests.version = testers.testVersion {
    package = gel-server;
    command = "gel-server --version";
  };

  meta = {
    description = "Gel database server";
    longDescription = ''
      Native Gel 7.1 server built against the Gel-tracked PostgreSQL
      fork (gel-postgresql, wired via EDGEDB_BUILD_PG_CONFIG). The
      in-tree postgres/UI builds never run here; pgvector and
      edb_stat_statements ship inside gel-postgresql.
    '';
    homepage = "https://github.com/geldata/gel";
    changelog = "https://github.com/geldata/gel/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "gel-server";
    # Linux-only review scope; Darwin builds are untested, do not advertise.
    platforms = lib.platforms.linux;
  };
}
