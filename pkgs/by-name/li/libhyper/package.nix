{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  clientSupport ? full,
  full ? true,
  http1Support ? full,
  http2Support ? full,
  serverSupport ? full,
  tracingSupport ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "libhyper";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "hyperium";
    repo = "hyper";
    rev = "refs/tags/v${version}";
    hash = "sha256-neFCZfMWm+FV+VlSXpvrxaGj+wF+exVDZv3JG4wiX7o=";
  };

  # Add a Cargo.lock
  #
  # Make sure rustc always emits cdylib artifacts
  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
    printf '[lib]\ncrate-type = ["cdylib"]' >> Cargo.toml
  '';

  cargoLock.lockFile = ./Cargo.lock;

  buildNoDefaultFeatures = true;
  buildFeatures =
    [ "ffi" ] # We always want this, so not optional
    ++ lib.optional (clientSupport || full) "client"
    ++ lib.optional (http1Support || full) "http1"
    ++ lib.optional (http2Support || full) "http2"
    ++ lib.optional (serverSupport || full) "server"
    ++ lib.optional tracingSupport "tracing";

  # Tests require the (equivalent to the) full feature set at minimum
  doCheck = full || clientSupport && http1Support && http2Support && serverSupport;

  # Doc tests complain about `--cfg hyper_unstable_ffi` being in RUSTFLAGS when
  # it is?
  cargoTestFlags = [
    "--lib"
    "--tests"
  ];

  postInstall = ''
    install -Dm755 $releaseDir/libhyper.so -t $out/lib
    install -Dm644 capi/include/hyper.h -t $out/include
  '';

  env = {
    # Required for FFI
    RUSTFLAGS = toString [
      "--cfg"
      "hyper_unstable_ffi"
    ];
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "HTTP library for Rust";
    homepage = "https://hyper.rs/";
    changelog = "https://github.com/hyperium/hyper/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
