{
  rustPlatform,
  lib,
  fetchFromGitHub,
  sqlcipher,
  fetchpatch,
  stdenv,
  openssl,
  tcl,
  buildEnv,
  rust-cbindgen,
}:
let
  signal-sqlcipher-extension = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "signal-sqlcipher-extension";
    version = "0.2.1";

    src = fetchFromGitHub {
      owner = "signalapp";
      repo = "Signal-Sqlcipher-Extension";
      tag = "v${finalAttrs.version}";
      hash = "sha256-INSkm7ZuetPASuIqezzzG/bXoEHClUb9XpxWbxLVXRc=";
    };
    useFetchCargoVendor = true;
    cargoHash = "sha256-qT4HM/FRL8qugKKNlMYM/0zgUsC6cDOa9fgd1d4VIrc=";

    meta = {
      description = "SQLite extension used by Signal Desktop";
      homepage = "https://github.com/signalapp/Signal-Sqlcipher-Extension";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ marcin-serwin ];
      platforms = lib.platforms.all;
    };
  });

  sqlcipher-amalgamation = stdenv.mkDerivation {
    pname = "sqlcipher-with-signal-extension";

    inherit (sqlcipher) version src meta;

    patches = [
      (fetchpatch {
        # https://github.com/sqlcipher/sqlcipher/pull/529
        name = "custom-crypto-provider.patch";
        url = "https://github.com/sqlcipher/sqlcipher/commit/0e3b20c155df8a2943b62a9f3cc0f4d3dba9e152.patch";
        hash = "sha256-OKh6qCGHBQWZyzXfyEveAs71wrNwlWLuG9jNqDeKNG4=";
      })
    ];

    nativeBuildInputs = [ tcl ];

    buildInputs = [ openssl ];

    CFLAGS = [ "-DSQLITE_ENABLE_UPDATE_DELETE_LIMIT=1" ];

    makeFlags = [ "sqlite3.c" ];

    installPhase = ''
      install -Dm644 sqlite3.c $out/src/sqlite3.c
      install -Dm644 sqlite3.h $out/include/sqlite3.h
      install -Dm644 sqlite3ext.h $out/include/sqlite3ext.h
    '';
  };

  signal-tokenizer-headers = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "Signal-FTS5-Extension";
    version = "0.2.1";

    src = fetchFromGitHub {
      owner = "signalapp";
      repo = "Signal-FTS5-Extension";
      tag = "v${finalAttrs.version}";
      hash = "sha256-MzgdRuRsfL3yhlVU0RAAUtAaOukMpqSSa42nRYhpmh0=";
    };
    useFetchCargoVendor = true;
    cargoHash = "sha256-0DDX3ciXk5/3MqsHzxV8s4qEhqYmrwGg7cSbrkFRZbw=";

    nativeBuildInputs = [ rust-cbindgen ];

    buildPhase = ''
      cbindgen --profile release . -o signal-tokenizer.h
    '';
    installPhase = ''
      install -Dm644 signal-tokenizer.h $out/include/signal-tokenizer.h
    '';
    doCheck = false;
  });

in
buildEnv {
  name = "sqlcipher-signal";

  paths = [
    sqlcipher-amalgamation
    signal-tokenizer-headers
    signal-sqlcipher-extension
  ];

  postBuild = ''
    install -Dm644 ${./sqlite3.gyp} $out/share/sqlite3.gyp
    substituteInPlace $out/share/sqlite3.gyp \
      --replace-fail "@extension@" "$out" \
      --replace-fail "@static_lib_ext@" "${stdenv.hostPlatform.extensions.staticLibrary}"
  '';
}
