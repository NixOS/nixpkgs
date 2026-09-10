{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  zig_0_16,
  installAgentSkills,
  installShellFiles,
  cctools,
  xcbuild,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "herdr";
  version = "0.9.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "herdrdev";
    repo = "herdr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N6+kprfWRyh0AkAiopkGsNXUGGORyPVFHEaDHCpGQs8=";
  };

  postPatch = ''
    substituteInPlace vendor/libghostty-vt/pkg/apple-sdk/native_link.zig \
      --replace-fail '"/usr/bin/xcrun"' '"xcrun"'

    substituteInPlace vendor/libghostty-vt/src/build/GhosttyLibVt.zig \
      --replace-fail '"/bin/ln"' '"ln"'

    substituteInPlace vendor/libghostty-vt/src/build/LibtoolStep.zig \
      --replace-fail '/bin/cp ' 'cp ' \
      --replace-fail '/usr/bin/ranlib ' 'ranlib '
  '';

  cargoHash = "sha256-1VAmsDE3zeU0wMVQKleQcd/zq8/k/oor8tasrsRQfeY=";

  zigDeps = zig_0_16.fetchDeps {
    inherit (finalAttrs) pname version;
    src = "${finalAttrs.src}/vendor/libghostty-vt";
    fetchAll = true;
    hash = "sha256-Cy0DdSvce+fhOFIfxHMQGF2b2j16UkS27UpGbfC42XI=";
  };

  nativeBuildInputs = [
    zig_0_16
    installAgentSkills
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    xcbuild
  ];

  # Upstream binary tests are renamed, added, or changed between releases and
  # depend on host process details, so Nix-only patches for them are brittle.
  doCheck = false;

  dontUseZigBuild = true;
  dontUseZigCheck = true;
  dontUseZigInstall = true;

  postConfigure = ''
    export ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)
    cp -rL ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
    chmod -R u+w "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd herdr \
      --bash <("$out/bin/herdr" completion bash) \
      --fish <("$out/bin/herdr" completion fish) \
      --zsh <("$out/bin/herdr" completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--custom-dep"
      "zigDeps"
    ];
  };

  meta = {
    description = "Agent multiplexer that lives in your terminal";
    homepage = "https://herdr.dev";
    changelog = "https://github.com/herdrdev/herdr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kevinpita
      faukah
    ];
    mainProgram = "herdr";
    platforms = lib.platforms.unix;
  };
})
