{
  lib,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  installShellFiles,
  nixosTests,
  stdenv,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "croc";
  version = "10.4.1";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = "croc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BUwb/M4+iXffZt2285fjw2UYBeqA5QVqUgQPy74EOtg=";
  };

  vendorHash = "sha256-/qPBHpCdEu1uBFFwE7uzmCcm4EL8TxUWdjiaFlUSxIU=";

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd croc \
      --bash src/install/bash_autocomplete \
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    --fish <($out/bin/croc generate-fish-completion) \
  ''
  + ''
    --zsh src/install/zsh_autocomplete
  '';

  passthru = {
    tests = {
      local-relay = callPackage ./test-local-relay.nix { };
      inherit (nixosTests) croc;
    };
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Easily and securely send things from one computer to another";
    longDescription = ''
      Croc is a command line tool written in Go that allows any two computers to
      simply and securely transfer files and folders.

      Croc does all of the following:
      - Allows any two computers to transfer data (using a relay)
      - Provides end-to-end encryption (using PAKE)
      - Enables easy cross-platform transfers (Windows, Linux, Mac)
      - Allows multiple file transfers
      - Allows resuming transfers that are interrupted
      - Does not require a server or port-forwarding
    '';
    homepage = "https://github.com/schollz/croc";
    changelog = "https://github.com/schollz/croc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      equirosa
      SuperSandro2000
      ryan4yin
    ];
    mainProgram = "croc";
  };
})
