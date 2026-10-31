{
  lib,
  stdenv,
  buildPackages,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "gibo";
  version = "3.0.23";

  src = fetchFromGitHub {
    owner = "simonwhitaker";
    repo = "gibo";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-tHhxLdMH7r/nfD7idxv6YCqqqe8XzCE9Y8PATAz9GYI=";
  };

  vendorHash = "sha256-kUd54Kqb16JMXCot5QQXudezN7z6Y0J5eHUqgNCT5GM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/simonwhitaker/gibo/cmd.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd gibo \
        --bash <(${emulator} $out/bin/gibo completion bash) \
        --fish <(${emulator} $out/bin/gibo completion fish) \
        --zsh <(${emulator} $out/bin/gibo completion zsh)
    ''
  );

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/simonwhitaker/gibo";
    license = lib.licenses.unlicense;
    description = "Shell script for easily accessing gitignore boilerplates";
    platforms = lib.platforms.unix;
    mainProgram = "gibo";
  };
})
