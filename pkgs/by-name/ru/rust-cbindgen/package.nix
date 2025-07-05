{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  python3Packages,
  makeBinaryWrapper,
  nix-update-script,
  cmake,
  cargo,
  rustc,

  # tests
  firefox-unwrapped,
  firefox-esr-unwrapped,
  mesa,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-cbindgen";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cbindgen";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wCl2GpHqF7wKIE8UFyZRY0M1hxonZek2FN6+5x/jGWI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BErgOnmatxpfF5Ip44WOqnEWOzOJaVP6vfhXPsF9wuc=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

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

  postInstall = ''
    wrapProgram "$out/bin/cbindgen" \
      --suffix PATH : ${
        lib.makeBinPath [
          cargo
          rustc
        ]
      }
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/cbindgen ${./bindgen-test}

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit
        firefox-unwrapped
        firefox-esr-unwrapped
        mesa
        ;
    };
  };

  meta = {
    changelog = "https://github.com/mozilla/cbindgen/blob/v${finalAttrs.version}/CHANGES";
    description = "Project for generating C bindings from Rust code";
    mainProgram = "cbindgen";
    homepage = "https://github.com/mozilla/cbindgen";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      hexa
      RossSmyth
    ];
  };
})
