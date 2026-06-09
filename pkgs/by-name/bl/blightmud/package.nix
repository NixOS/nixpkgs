{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  alsa-lib,
  openssl,
  withTTS ? false,
  speechd-minimal,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blightmud";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "blightmud";
    repo = "blightmud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M+tbV8zuwnwwv335ljKIq0UIsSkb4SQnJnOtOhL25N8=";
  };

  cargoHash = "sha256-EWI+k+q8JdyZDw+k2pM1mRkfBDQH0IsuzgrTECLrHt0=";

  postPatch = ''
    substituteInPlace Cargo.toml --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  buildFeatures = lib.optional withTTS "tts";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals (withTTS && stdenv.hostPlatform.isLinux) [ speechd-minimal ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  env = lib.optionalAttrs (!stdenv.cc.isClang) {
    NIX_CFLAGS_COMPILE = "-std=gnu17";
  };

  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      # Most of Blightmud's unit tests pass without trouble in the isolated
      # Nixpkgs build env. The following tests need to be skipped.
      skipList = [
        "test_connect"
        "test_gmcp_negotiation"
        "test_ttype_negotiation"
        "test_reconnect"
        "test_is_connected"
        "test_mud"
        "test_server"
        "test_lua_script"
        "timer_test"
        "validate_assertion_fail"
        "regex_smoke_test"
        "test_tls_init_verify_err"
        "test_tls_init_no_verify"
        "test_tls_init_verify"
        "test_exec"
        "test_line_tags"
        "test_lua_api"
        "test_suggest"
        "test_mccp2_decompression"
        "test_mccp2_incremental"
        "test_mccp2_negotiation"
      ];
    in
    builtins.map (x: "--skip=" + x) skipList;

  meta = {
    description = "Terminal MUD client written in Rust";
    mainProgram = "blightmud";
    longDescription = ''
      Blightmud is a terminal client for connecting to Multi User Dungeon (MUD)
      games. It is written in Rust and supports TLS, GMCP, MSDP, MCCP2, tab
      completion, text searching and a split view for scrolling. Blightmud can
      be customized with Lua scripting for aliases, triggers, timers, customized
      status bars, and more. Blightmud supports several accessibility features
      including an optional built-in text-to-speech engine and a screen reader
      friendly mode.
    '';
    homepage = "https://github.com/Blightmud/Blightmud";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ cpu ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
