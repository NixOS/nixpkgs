{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  callPackage,
  installShellFiles,
  nixosTests,
  stdenv,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "croc";
  version = "11.5.4";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = "croc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QF++O86FqyTE/s0BiFhFts80/DCXPU1xAqeTMtviE2E=";
  };

  vendorHash = "sha256-eiuycihsdYZqdobRsMlryyQOhOeDIUAyM7cUavTPv+o=";

  subPackages = [ "." ];

  # The root package's interrupt tests start a local relay, which needs to bind
  # a port inside the Darwin sandbox.
  __darwinAllowLocalNetworking = true;

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
      ryan4yin
      kaynetik
    ];
    mainProgram = "croc";
  };
})
