{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchurl,
  installShellFiles,
  libcap_ng,
  versionCheckHook,
}:

let
  inherit (stdenv.hostPlatform) system;

  sources = import ./sources.nix { inherit fetchurl; };

  source = sources.${system} or (throw "microsandbox is not available for ${system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "microsandbox";

  # Upstream publishes one audited bundle per platform. Each contains the msb
  # CLI with the guest agentd embedded, and the matching libkrunfw firmware.
  # Building libkrunfw here would mean compiling their kernel fork
  # superradcompany/libkrunfw 5.6.1. nixpkgs only carries libkrunfw 5.5.0.
  inherit (source) version src;

  sourceRoot = ".";

  __structuredAttrs = true;
  strictDeps = true;

  # The bundle arrives linked. On macOS it is ad-hoc signed with the hypervisor
  # entitlement, and stripping breaks that signature.
  dontStrip = true;

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  # msb needs libcap-ng and libgcc_s at runtime. autoPatchelfHook only searches
  # the dependencies of the derivation, so libgcc_s has to be named.
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libcap_ng
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 msb "$out/bin/msb"
    ln -s msb "$out/bin/microsandbox"

    # msb looks for the firmware next to the executable it was started from, or
    # in ../lib. This layout matches the upstream ~/.microsandbox install, so
    # msb does not fetch the firmware at runtime.
    mkdir -p "$out/lib"
    install -m644 libkrunfw.* "$out/lib/"

    runHook postInstall
  '';

  # autoPatchelfHook registers in postFixupHooks, which run after the postFixup
  # script. Running it here first means the completions come from a binary that
  # already has an interpreter and an RPATH.
  dontAutoPatchelf = true;

  postFixup =
    lib.optionalString
      (stdenv.hostPlatform.isLinux && stdenv.buildPlatform.canExecute stdenv.hostPlatform)
      ''
        autoPatchelf "$out"
      ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''

      installShellCompletion --cmd msb \
        --bash <("$out/bin/msb" completion bash) \
        --zsh <("$out/bin/msb" completion zsh) \
        --fish <("$out/bin/msb" completion fish)
    '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/superradcompany/microsandbox/releases/tag/v${finalAttrs.version}";
    description = "Fast, local microVMs for running untrusted code";
    homepage = "https://microsandbox.dev";
    license = with lib.licenses; [ asl20 ];
    mainProgram = "msb";
    maintainers = with lib.maintainers; [ djmaze ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
