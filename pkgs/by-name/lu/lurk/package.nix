{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lurk";
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "jakwai01";
    repo = "lurk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q7lxPjEfzbGPes11fP7qJY4cYetem7tKQasQcy67oRU=";
  };

  cargoHash = "sha256-QOdqA3gHfhBUWL5CHA5p4ueKwZusE5NBlGezBG//3FA=";

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
