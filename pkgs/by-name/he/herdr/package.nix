{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  zig_0_15,
  installShellFiles,
  cctools,
  xcbuild,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "herdr";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "herdrdev";
    repo = "herdr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-empFQ+hrnCh2JhOzQRWSCLV0YoZC3DXW3bY6k8YuJjk=";
  };

  cargoHash = "sha256-E1lBgpTFZwNjeALeg/atwbDFL/XQbUnvCdX7ohbAHAc=";

  zigDeps = zig_0_15.fetchDeps {
    inherit (finalAttrs) pname version;
    src = "${finalAttrs.src}/vendor/libghostty-vt";
    fetchAll = true;
    hash = "sha256-PnM+hZIlLyQwK8vJgd/Bhjt1lNIz06T8FahwliRmMrY=";
  };

  nativeBuildInputs = [
    zig_0_15.hook
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

  postInstall = ''
    mkdir --parents "$out"/share/herdr/skills/herdr
    "$out"/bin/herdr --skill > "$_"/SKILL.md
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
