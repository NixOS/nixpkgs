{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mago";
  version = "1.45.0";

  src = fetchFromGitHub {
    owner = "carthage-software";
    repo = "mago";
    tag = finalAttrs.version;
    hash = "sha256-ue1jf2fdus6a6XHhNBL21cIaHtX46av2AQUBcRs0W44=";
    forceFetchGit = true; # Does not download all files otherwise
  };

  cargoHash = "sha256-fViy3y1ipphSwh9NsFVR8hEUya/juQ1WCvqrzZpwsRU=";

  env = {
    # Get openssl-sys to use pkg-config
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mago \
      --bash <("$out/bin/mago" generate-completions bash) \
      --zsh <("$out/bin/mago" generate-completions zsh) \
      --fish <("$out/bin/mago" generate-completions fish)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/carthage-software/mago/releases/tag/${finalAttrs.version}";
    description = "Toolchain for PHP that aims to provide a set of tools to help developers write better code";
    homepage = "https://github.com/carthage-software/mago";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      atomicptr
      hythera
      patka
    ];
    mainProgram = "mago";
  };
})
