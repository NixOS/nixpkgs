{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  bubblewrap,
  clang,
  cmake,
  gitMinimal,
  libcap,
  libclang,
  buildRustyV8,
  livekit-libwebrtc,
  lld,
  makeBinaryWrapper,
  nix-update-script,
  pkg-config,
  openssl,
  ripgrep,
  versionCheckHook,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:
let
  librusty_v8 = buildRustyV8 rec {
    version = "146.4.0";
    src = fetchFromGitHub {
      owner = "denoland";
      repo = "rusty_v8";
      tag = "v${version}";
      fetchSubmodules = true;
      hash = "sha256-ABlfRtfkxyOCs8dpsSBx3UMYYRz9rUAb7N6CpQgZdMU=";
    };
    cargoHash = "sha256-R629/gy46x5pXR9Ig0XCcv42nGHhq0e+n/QaNDCAvXs=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex";
  version = "0.142.3";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${finalAttrs.version}";
    hash = "sha256-dxkyaWpgzqpAVFojDYQ6JpMPNBIX+d7xjIyLic4Cs8A=";
  };

  sourceRoot = "${finalAttrs.src.name}/codex-rs";

  cargoHash = "sha256-1gDiCB3Nf/0aIm+EoL3g9C0xbCi3cv6TfH5VytjJpOY=";

  __structuredAttrs = true;

  # Match upstream's release build for the codex binary only.
  cargoBuildFlags = [
    "--package"
    "codex-cli"
  ];
  cargoCheckFlags = [
    "--package"
    "codex-cli"
  ];

  postPatch = ''
    # webrtc-sys asks rustc to link libwebrtc statically by default,
    # but nixpkgs provides libwebrtc as a shared library.
    # use LK_CUSTOM_WEBRTC to point to the packaged library and adjust linking
    # to use the shared library instead
    substituteInPlace $cargoDepsCopy/*/webrtc-sys-*/build.rs \
      --replace-fail "cargo:rustc-link-lib=static=webrtc" "cargo:rustc-link-lib=dylib=webrtc" \
      --replace-fail "framework=Appkit" "framework=AppKit"
    substituteInPlace Cargo.toml \
      --replace-fail 'lto = "thin"' "" \
      --replace-fail 'codegen-units = 4' ""
  '';

  nativeBuildInputs = [
    clang
    cmake
    gitMinimal
    installShellFiles
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    libclang
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
  ];

  # NOTE: set LIBCLANG_PATH so bindgen can locate libclang, and adjust
  # warning-as-error flags to avoid known false positives (GCC's
  # stringop-overflow in BoringSSL's a_bitstr.cc) while keeping Clang's
  # character-conversion warning-as-error disabled.
  env = {
    LIBCLANG_PATH = "${lib.getLib libclang}/lib";
    LK_CUSTOM_WEBRTC = lib.getDev livekit-libwebrtc;
    NIX_CFLAGS_COMPILE = toString (
      lib.optionals stdenv.cc.isGNU [
        "-Wno-error=stringop-overflow"
      ]
      ++ lib.optionals stdenv.cc.isClang [
        "-Wno-error=character-conversion"
      ]
    );
    RUSTY_V8_ARCHIVE = librusty_v8;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Link with lld on Darwin. nixpkgs' classic open-source ld64 fails to insert
    # ARM64 branch thunks for this binary, producing `b(l) ARM64 branch out of range`.
    NIX_CFLAGS_LINK = "-fuse-ld=${lib.getExe' lld "ld64.lld"}";
  };

  # NOTE: part of the test suite requires access to networking, local shells,
  # apple system configuration, etc. since this is a very fast moving target
  # (for now), with releases happening every other day, constantly figuring out
  # which tests need to be skipped, or finding workarounds, was too burdensome,
  # and in practice not adding any real value. this decision may be reversed in
  # the future once this software stabilizes.
  doCheck = false;

  postInstall = lib.optionalString installShellCompletions ''
    installShellCompletion --cmd codex \
      --bash <($out/bin/codex completion bash) \
      --fish <($out/bin/codex completion fish) \
      --zsh <($out/bin/codex completion zsh)
  '';

  postFixup = ''
    wrapProgram $out/bin/codex --prefix PATH : ${
      lib.makeBinPath ([ ripgrep ] ++ lib.optionals stdenv.hostPlatform.isLinux [ bubblewrap ])
    }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--use-github-releases"
        "--version-regex"
        "^rust-v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
    inherit librusty_v8;
  };

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    changelog = "https://raw.githubusercontent.com/openai/codex/refs/tags/rust-v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "codex";
    maintainers = with lib.maintainers; [
      delafthi
      jeafleohj
      malo
    ];
    platforms = lib.platforms.unix;
  };
})
