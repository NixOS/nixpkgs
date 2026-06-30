{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
  zlib,
  testers,
  incus-spawn,
}:

let
  stdenv = stdenvNoCC;
  version = "0.2.7";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/Sanne/incus-spawn/releases/download/v${version}/incus-spawn-linux-amd64";
      hash = "sha256-jgdNuVfVshbg8piAGGpIy4cnJj5glbsGqOENDBoqpzI=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/Sanne/incus-spawn/releases/download/v${version}/incus-spawn-linux-aarch64";
      hash = "sha256-Y7OaNgQKAN/HVt75+tawrCtkyZdAHfAiUxx2a0eD5P8=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/Sanne/incus-spawn/releases/download/v${version}/incus-spawn-macos-aarch64";
      hash = "sha256-Uv0v7LxIcB0oNEnW1vK9Iy6MOwxoUeqtszGfsS5wt6k=";
    };
  };

  git-remote-isx = fetchurl {
    url = "https://github.com/Sanne/incus-spawn/releases/download/v${version}/git-remote-isx";
    hash = "sha256-I9zmdLzO7VcfLHdgFD2Lvwiq4fkDw885j1JWsL8c+hA=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "incus-spawn";
  inherit version;

  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  dontUnpack = true;
  dontBuild = true;
  dontStrip = stdenv.hostPlatform.isDarwin;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    zlib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/isx
    install -Dm755 ${git-remote-isx} $out/bin/git-remote-isx

    runHook postInstall
  '';

  # Generate shell completions after autoPatchelfHook has patched the ELF binary.
  # On Linux, autoPatchelfHook runs in postFixupHooks so we use installCheckPhase
  # which runs after fixup is fully complete. On Darwin no patching is needed but
  # we keep the same phase for consistency.
  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck

    installShellCompletion --cmd isx \
      --bash <($out/bin/isx completion bash) \
      --zsh <($out/bin/isx completion zsh) \
      --fish <($out/bin/isx completion fish)

    runHook postInstallCheck
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = incus-spawn;
      command = "isx --version";
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "CLI tool for managing isolated Incus development environments";
    longDescription = ''
      incus-spawn (isx) creates isolated Linux development environments using
      Incus system containers with copy-on-write branching, a MITM TLS proxy
      for credential isolation, and an interactive TUI.
    '';
    homepage = "https://github.com/Sanne/incus-spawn";
    changelog = "https://github.com/Sanne/incus-spawn/releases/tag/v${version}";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "isx";
    maintainers = with lib.maintainers; [
      galder
    ];
  };
})
