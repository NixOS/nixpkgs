{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  libiconv,
  darwin,
  testers,
  llm-ls,
}:

let
  pname = "llm-ls";
  version = "0.5.3";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "llm-ls";
    rev = version;
    hash = "sha256-ICMM2kqrHFlKt2/jmE4gum1Eb32afTJkT3IRoqcjJJ8=";
  };

  cargoHash = "sha256-m/w9aJZCCh1rgnHlkGQD/pUDoWn2/WRVt5X4pFx9nC4=";

  cargoPatches = [
    # https://github.com/huggingface/llm-ls/pull/102
    ./fix-time-compilation-failure.patch
    (fetchpatch {
      name = "fix-version.patch";
      url = "https://github.com/huggingface/llm-ls/commit/479401f3a5173f2917a888c8068f84e29b7dceed.patch?full_index=1";
      hash = "sha256-4gXasfMqlrrP8II+FiV/qGfO7a9qFkDQMiax7yEua5E=";
    })
  ];

  buildAndTestSubdir = "crates/llm-ls";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      libiconv
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  passthru.tests.version = testers.testVersion {
    package = llm-ls;
  };

  meta = with lib; {
    description = "LSP server leveraging LLMs for code completion (and more?)";
    homepage = "https://github.com/huggingface/llm-ls";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfvillablanca ];
    platforms = platforms.all;
    mainProgram = "llm-ls";
  };
}
