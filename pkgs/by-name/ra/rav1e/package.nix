{
  lib,
  rust,
  stdenv,
  rustPlatform,
  fetchCrate,
  cargo-c,
  nasm,
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

  cargoHash = "sha256-VyQ6n2kIJ7OjK6Xlf0T0GNsBvgESRETzKZDZzAn8ZuY=";

  nativeBuildInputs = [
    cargo-c
    nasm
  ];

  postPatch =
    ''
      # remove feature that requires libgit2 and is only used to print a version string
      substituteInPlace Cargo.toml --replace-fail '"git_version",' ""
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
      # Darwin uses `llvm-strip`, which results in link errors when using `-x` to strip the asm library
      # and linking it with cctools ld64.
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
