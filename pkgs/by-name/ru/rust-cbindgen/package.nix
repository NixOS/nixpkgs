{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  python3Packages,

  # tests
  firefox-unwrapped,
  firefox-esr-unwrapped,
  mesa,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-cbindgen";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cbindgen";
    rev = "v${version}";
    hash = "sha256-1GT+EgltLhveEACxhY+748L1HIIyQHbEs7wLKANFWr0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-k8n3adoqKp/RXkHybCKV2KlVnaoEhM6vF57BqeCDAP4=";

  nativeCheckInputs = [
    cmake
    python3Packages.cython
  ];

  checkFlags =
    [
      # Disable tests that require rust unstable features
      # https://github.com/eqrion/cbindgen/issues/338
      "--skip test_expand"
      "--skip test_bitfield"
      "--skip lib_default_uses_debug_build"
      "--skip lib_explicit_debug_build"
      "--skip lib_explicit_release_build"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # WORKAROUND: test_body fails when using clang
      # https://github.com/eqrion/cbindgen/issues/628
      "--skip test_body"
    ];

  passthru.tests = {
    inherit
      firefox-unwrapped
      firefox-esr-unwrapped
      mesa
      ;
  };

  meta = {
    changelog = "https://github.com/mozilla/cbindgen/blob/v${version}/CHANGES";
    description = "Project for generating C bindings from Rust code";
    mainProgram = "cbindgen";
    homepage = "https://github.com/mozilla/cbindgen";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
