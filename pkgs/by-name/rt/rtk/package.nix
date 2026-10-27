{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  sqlite,
  gitMinimal,
  curl,
  jq,
  coreutils,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rtk";
  version = "1.0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rtk-ai";
    repo = "rtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8nf2q6SGupoOqaf97TdD37lSCj7cMNfYGwX+42mWz1k=";
  };

  cargoHash = "sha256-WoBuQ+Meml4wXSp8bQTckjvjriKsSOs0vSijWo0frq8=";

  postPatch = ''
    substituteInPlace tests/run_shell_test.rs \
      --replace-fail /usr/bin/printf ${lib.getExe' coreutils "printf"} \
      --replace-fail /bin/echo ${lib.getExe' coreutils "echo"} \
      --replace-fail /bin/true ${lib.getExe' coreutils "true"} \
      --replace-fail /bin/false ${lib.getExe' coreutils "false"}
  '';

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    sqlite
  ];

  env.LIBSQLITE3_SYS_USE_PKG_CONFIG = "1";
  postInstall = ''
    wrapProgram $out/bin/rtk \
      --prefix PATH : ${
        lib.makeBinPath [
          gitMinimal
        ]
      }
  '';

  nativeCheckInputs = [
    curl
    gitMinimal
    jq
    writableTmpDirAsHomeHook
  ];

  checkFlags = [
    # Waits on a shim subprocess that never gets scheduled inside the build sandbox, so it only ever
    # fails on its own 60s timeout.
    "--skip=signalled_run_still_prints_captured_output"
  ];

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    # Upstream also publishes `dev-<version>-rc.<n>` prerelease tags.
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "CLI proxy that reduces LLM token consumption by 60-90% on common dev commands";
    homepage = "https://github.com/rtk-ai/rtk";
    changelog = "https://github.com/rtk-ai/rtk/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      bsl11
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "rtk";
  };
})
