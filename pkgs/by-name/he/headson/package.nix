{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "headson";
  version = "0.17.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kantord";
    repo = "headson";
    tag = "headson-v${finalAttrs.version}";
    hash = "sha256-m5VAW38RrvnQddbFPndAJYygtczPZV57sfDIZYAEWBc=";
    # The repository root has both LICENSE and License (a stray copy of the
    # yaml-test-suite license), which collide on case-insensitive filesystems
    # and give Darwin a different source hash.  Remove both so that every
    # platform sees the same tree.
    postFetch = ''
      rm -f "$out/LICENSE" "$out/License"
    '';
  };

  cargoHash = "sha256-Sv8jMzkKC6EFSrrFEWA5EvK51LD44erTpkdRco4OrQY=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hson \
      --bash <("$out/bin/hson" --completions bash) \
      --fish <("$out/bin/hson" --completions fish) \
      --zsh <("$out/bin/hson" --completions zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "headson-v(.*)"
    ];
  };

  meta = {
    description = "`head`/`tail` for structured data";
    longDescription = ''
      Structure-aware `head`/`tail` for JSON and YAML.  Get a compact
      preview that shows both the shape and representative values of
      your data, all within a strict byte budget.  (Just like
      `head`/`tail`, `headson` can also work with unstructured text
      files.)
    '';
    homepage = "https://github.com/kantord/headson";
    changelog = "https://github.com/kantord/headson/blob/headson-v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "hson";
  };
})
