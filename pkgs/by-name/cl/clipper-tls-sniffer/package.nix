{ rustPlatform, stdenv, lib, fridaPackages, slirp4netns, glib, pkg-config, protobuf, makeWrapper, openssl }:
let
  wrapperArgs = lib.optionals stdenv.isLinux [
    "--prefix PATH ':' '${slirp4netns}/bin'"
  ];
in
rustPlatform.buildRustPackage {
  pname = "clipper-tls-sniffer";
  version = "0.1.0";

  # TODO
  src = builtins.fetchGit { name = "source"; url = /home/jade/dev/clipper; };

  doCheck = true;
  # Likely cause is https://github.com/lf-/clipper/issues/14
  checkType = "debug";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "chromiumoxide_cdp-0.5.0" = "sha256-qJYD7N+LNgOX2UnJ1VukbKnhpEZIZcaoMkIWiXQ/nU4=";
    };
  };

  env = {
    # Avoid requiring nightly Rust.
    RUSTC_BOOTSTRAP = 1;
  };

  preConfigure = ''
    export BINDGEN_EXTRA_CLANG_ARGS="$BINDGEN_EXTRA_CLANG_ARGS -isystem ${fridaPackages.frida-gum}"
  '';

  postFixup = ''
    # delete test fixtures
    rm $out/bin/*-fixture
    wrapProgram $out/bin/clipper --inherit-argv0 ${builtins.toString wrapperArgs}
  '';

  # clipper_inject only is supported on Linux (https://github.com/lf-/clipper/issues/10)
  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    glib
    fridaPackages.frida-gum
  ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    protobuf
    makeWrapper
  ] ++ lib.optional stdenv.isLinux slirp4netns;

  meta = with lib; {
    description = "Easy and fast TLS interception for debugging";
    longDescription = "A toolkit for TLS interception allowing viewing TLS traffic of native applications in Chrome dev tools, capturing pcapng files with keys for later analysis, and more";
    homepage = "https://github.com/lf-/clipper";
    maintainers = [ maintainers.lf- ];
    platforms = platforms.unix;
    mainProgram = "clipper";
  };
}
