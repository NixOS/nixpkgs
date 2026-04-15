{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  zlib,
  zstd,
  pkg-config,
  python3,
  libx11,
  nghttp2,
  libgit2,
  withDefaultFeatures ? true,
  additionalFeatures ? (p: p),
  nix-update-script,
  curlMinimal,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nushell";
  # NOTE: when updating this to a new non-patch version, please also try to
  # update the plugins. Plugins only work if they are compiled for the same
  # major/minor version.
  version = "0.112.1";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    tag = finalAttrs.version;
    hash = "sha256-y0EfP95XEVvse0xaSWK5Yr748tTVYRG7Bx+Qf5JrlYY=";
  };

  cargoHash = "sha256-Y/yaWj2akccehFVxrGHrsjzZd02L8qE9KoSSwzAeEwg=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals (withDefaultFeatures && stdenv.hostPlatform.isLinux) [ python3 ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs = [
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ zlib ]
  ++ lib.optionals (withDefaultFeatures && stdenv.hostPlatform.isLinux) [ libx11 ]
  ++ lib.optionals (withDefaultFeatures && stdenv.hostPlatform.isDarwin) [
    nghttp2
    libgit2
  ];

  buildNoDefaultFeatures = !withDefaultFeatures;
  buildFeatures = additionalFeatures [ ];

  preCheck = ''
    export NU_TEST_LOCALE_OVERRIDE="en_US.UTF-8"
  '';

  checkPhase =
    let
      # The skipped tests all fail in the sandbox because in the nushell test playground,
      # the tmp $HOME is not set, so nu falls back to looking up the passwd dir of the build
      # user (/var/empty). The assertions however do respect the set $HOME.
      skippedTests = [
        "repl::test_config_path::test_default_config_path"
        "repl::test_config_path::test_xdg_config_bad"
        "repl::test_config_path::test_xdg_config_empty"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "plugins::config::some"
        "plugins::stress_internals::test_exit_early_local_socket"
        "plugins::stress_internals::test_failing_local_socket_fallback"
        "plugins::stress_internals::test_local_socket"

        # Error:   × I/O error: Operation not permitted (os error 1)
        "shell::environment::env::path_is_a_list_in_repl"
      ];

      skippedTestsStr = lib.concatStringsSep " " (lib.map (testId: "--skip=${testId}") skippedTests);
    in
    ''
      runHook preCheck

      cargo test -j $NIX_BUILD_CORES --offline -- \
        --test-threads=$NIX_BUILD_CORES ${skippedTestsStr}

      runHook postCheck
    '';

  nativeCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  checkInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [ curlMinimal ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  passthru = {
    shellPath = "/bin/nu";
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      johntitor
      joaquintrinanes
      ryan4yin
    ];
    mainProgram = "nu";
  };
})
