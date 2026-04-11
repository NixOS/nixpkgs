{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,

  # runtime dependencies
  ripgrep,
  which,
  # linux-only
  bubblewrap,
  socat,

  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "sandbox-runtime";
  version = "0.0.49";

  src = fetchFromGitHub {
    owner = "anthropic-experimental";
    repo = "sandbox-runtime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1QwUOtgOYcVm61nLCeQL46O/+G/LyXSv+ZnC3la2Ajc=";
  };

  postPatch =
    # Fix the `--version` flag.
    ''
      substituteInPlace src/cli.ts \
        --replace-fail "1.0.0" "${finalAttrs.version}"
    '';

  strictDeps = true;

  npmDepsHash = "sha256-YAzekNE9lOEMRaaGqLdpXMXgqh4kfGp4CF54ShS3xwA=";

  postFixup =
    let
      runtimeDeps = [
        ripgrep
        which
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        bubblewrap
        socat
      ];
    in
    ''
      wrapProgram $out/bin/srt \
        --prefix PATH ${lib.makeBinPath runtimeDeps}
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight sandboxing tool for enforcing filesystem and network restrictions on arbitrary processes at the OS level, without requiring a container";
    changelog = "https://github.com/anthropic-experimental/sandbox-runtime/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/anthropic-experimental/sandbox-runtime";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "srt";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
