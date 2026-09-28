{
  lib,
  stdenv,
  cmake,
  fetchurl,
  kytea,
  libstemmer,
  msgpack-c,
  mecab,
  pkg-config,
  rapidjson,
  testers,
  xxhash,
  zstd,
  versionCheckHook,
  postgresqlPackages,
  suggestSupport ? false,
  zeromq,
  libevent,
  lz4Support ? false,
  lz4,
  zlibSupport ? true,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "groonga";
  version = "16.1.1";

  src = fetchurl {
    url = "https://packages.groonga.org/source/groonga/groonga-${finalAttrs.version}.tar.gz";
    hash = "sha256-94u5rLxaW0xued2W++xQ2YvYB/+bqV3JMfD43zDhzI8=";
  };

  patches = [
    ./fix-cmake-install-path.patch
    ./do-not-use-vendored-libraries.patch
  ];

  nativeBuildInputs = [
    cmake
    mecab # mecab-config
    pkg-config
  ];

  buildInputs = [
    rapidjson
    xxhash
    zstd
    mecab
    kytea
    libstemmer
    msgpack-c
  ]
  ++ lib.optionals lz4Support [
    lz4
  ]
  ++ lib.optionals zlibSupport [
    zlib
  ]
  ++ lib.optionals suggestSupport [
    zeromq
    libevent
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString zlibSupport "-I${zlib.dev}/include";

  strictDeps = true;
  __structuredAttrs = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.tests = {
    inherit (postgresqlPackages) pgroonga;
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "groonga" ];
    };
  };

  meta = {
    homepage = "https://groonga.org/";
    changelog = "https://groonga.org/docs/news/${lib.versions.major finalAttrs.version}.html#release-${
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }";
    description = "Open-source fulltext search engine and column store";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ anish ];
    platforms = lib.platforms.all;
    mainProgram = "groonga";
    longDescription = ''
      Groonga is an open-source fulltext search engine and column store.
      It lets you write high-performance applications that requires fulltext search.
    '';
  };
})
