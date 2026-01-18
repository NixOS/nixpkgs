{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lurk";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "jakwai01";
    repo = "lurk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sng+mMMKDuI1aSgusJDRFMT5iKNUlp9arp9ruRn0bb0=";
  };

  patches = [
    (fetchpatch {
      name = "fix-aarch64-build.patch";
      url = "https://github.com/JakWai01/lurk/commit/132e6557ddeafbdb1bb1d4d1411099f0d7df7a51.patch?full_index=1";
      hash = "sha256-B5rNLipnFFWxIhTm+eCacJkw38D7stQ27WIHzgj7Vy0=";
    })
  ];

  cargoHash = "sha256-Cmlhhda35FmNg/OvfMRPHBLPRXF5bs0ebBYT7KfierA=";

  postPatch = ''
    substituteInPlace src/lib.rs \
      --replace-fail '/usr/bin/ls' 'ls'
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/jakwai01/lurk/releases/tag/v${finalAttrs.version}";
    description = "Simple and pretty alternative to strace";
    homepage = "https://github.com/jakwai01/lurk";
    license = lib.licenses.agpl3Only;
    mainProgram = "lurk";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
