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
  version = "0.0.83";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "sandbox-runtime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t+Xky8dJXu11C9Zdl2dAWl5FryYGbZDTdxVTm3xOfNc=";
  };

  npmDepsHash = "sha256-di2CbKfrlpiJWUgqSmklG3Uz+yxVFsSU2kBVb0U2cy0=";

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
        --prefix PATH : ${lib.makeBinPath runtimeDeps}
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight sandboxing tool for enforcing filesystem and network restrictions on arbitrary processes at the OS level, without requiring a container";
    changelog = "https://github.com/anthropics/sandbox-runtime/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/anthropics/sandbox-runtime";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "srt";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
