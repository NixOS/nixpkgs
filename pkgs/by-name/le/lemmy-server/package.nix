{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  aws-lc,
  libpq,
  rust-jemalloc-sys,
  zstd,
  libiconv,
  pkg-config,
  protobuf,
  rustfmt,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lemmy-server";
  version = "0.19.21";

  src = fetchFromGitHub {
    owner = "LemmyNet";
    repo = "lemmy";
    tag = finalAttrs.version;
    hash = "sha256-8PB3/XoDqzaptwwzqZSZjPYIcEHoasXsKPn1wwIUsEw=";
    fetchSubmodules = true;
  };

  preConfigure = ''
    echo 'pub const VERSION: &str = "${finalAttrs.version}";' > crates/utils/src/version.rs
  '';

  cargoHash = "sha256-GjuP5ci1f6xGGrDkS8KyfP15Owj42YNITfK3T4MuHp0=";

  buildInputs = [
    aws-lc
    libpq
    rust-jemalloc-sys
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  env = {
    PROTOC = "${protobuf}/bin/protoc";
    PROTOC_INCLUDE = "${protobuf}/include";

    # #[deny(warnings)] trips on newer rustc
    RUSTFLAGS = "--cap-lints warn";
  };
  nativeBuildInputs = [
    pkg-config
    protobuf
    rustfmt
  ];

  checkFlags = [
    # test requires database access
    "--skip=session_middleware::tests::test_session_auth"

    # tests require network access
    "--skip=scheduled_tasks::tests::test_nodeinfo_mastodon"
    "--skip=scheduled_tasks::tests::test_nodeinfo_lemmy_ml"
  ];

  # This gets installed automatically by cargoInstallHook,
  # but we don't actually need it, and it leaks a reference to rustc.
  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    rm $out/lib/libhtml2md.so
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.lemmy-server = nixosTests.lemmy;
  };

  meta = {
    description = "Federated link aggregator and forum";
    homepage = "https://join-lemmy.org/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      happysalada
      billewanick
      georgyo
      lucasew
    ];
    teams = [ lib.teams.ngi ];
    mainProgram = "lemmy_server";
  };
})
