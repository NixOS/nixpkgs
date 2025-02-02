{
  lib,
  rust,
  stdenv,
  rustPlatform,
  fetchCrate,
  pkg-config,
  cargo-c,
  nasm,
  libgit2,
  zlib,
  nix-update-script,
  testers,
  rav1e,
}:

rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.7.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Db7qb7HBAy6lniIiN07iEzURmbfNtuhmgJRv7OUagUM=";
  };

  # update built to be able to use the system libgit2
  cargoPatches = [ ./update-built.diff ];
  cargoHash = "sha256-Ud9Vw31y8nLo0aC3j7XY1+mN/pRvH9gJ0uIq73hKy3Y=";

  depsBuildBuild = [
    pkg-config
    libgit2
    zlib
  ];

  nativeBuildInputs = [
    cargo-c
    nasm
  ];

  env.LIBGIT2_NO_VENDOR = 1;

  # Darwin uses `llvm-strip`, which results in link errors when using `-x` to strip the asm library
  # and linking it with cctools ld64.
  postPatch = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    substituteInPlace build.rs --replace-fail '.arg("-x")' '.arg("-S")'
    # Thin LTO doesn’t appear to work with Rust 1.79. rav1e fail to build when building fern.
    substituteInPlace Cargo.toml --replace-fail 'lto = "thin"' 'lto = "fat"'
  '';

  checkType = "debug";

  postBuild = ''
    ${rust.envVars.setEnv} cargo cbuild --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
  '';

  postInstall = ''
    ${rust.envVars.setEnv} cargo cinstall --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
  '';

  passthru = {
    tests.version = testers.testVersion { package = rav1e; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fastest and safest AV1 encoder";
    longDescription = ''
      rav1e is an AV1 video encoder. It is designed to eventually cover all use
      cases, though in its current form it is most suitable for cases where
      libaom (the reference encoder) is too slow.
      Features: https://github.com/xiph/rav1e#features
    '';
    homepage = "https://github.com/xiph/rav1e";
    changelog = "https://github.com/xiph/rav1e/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "rav1e";
  };
}
