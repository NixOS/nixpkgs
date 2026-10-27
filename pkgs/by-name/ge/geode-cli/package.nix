{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "geode-cli";
  version = "3.9.0";

  geode = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/geode${stdenv.hostPlatform.extensions.executable}";

  src = fetchFromGitHub {
    owner = "geode-sdk";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mRvN5kp2AtOSQDPWjk3DBhWgMPXzuATjdu+CPGDHY3E=";
  };

  cargoHash = "sha256-gfJXXRv0jofwjf/pmrIOD7CWQk1b/xecAW8ptTC9K6k=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
  ];

  postFixup = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
    installShellCompletion --cmd geode \
      --fish <(${finalAttrs.geode} completions fish) \
      --bash <(${finalAttrs.geode} completions bash) \
      --zsh <(${finalAttrs.geode} completions zsh) \
      --nushell <(${finalAttrs.geode} completions nushell)

    installManPage --name geode.1 <(${finalAttrs.geode} generate-manpage)
  '';

  __structuredAttrs = true;

  meta = {
    description = "Command-line utilities for working with geode";
    homepage = "https://github.com/geode-sdk/cli";
    changelog = "https://github.com/geode-sdk/cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ not-a-cowfr ];
    mainProgram = "geode";
  };
})
