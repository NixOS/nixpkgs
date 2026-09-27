{
  buildFeatures ? [ ],
  buildNoDefaultFeatures ? false,
  buildPackages,
  fetchFromGitHub,
  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installShellFiles,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

let
  nativeTls = builtins.elem "native-tls" buildFeatures;

in
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  inherit buildFeatures buildNoDefaultFeatures;

  pname = "himalaya";
  version = "2.1.0";
  cargoHash = "sha256-aBNgXnAjyNYe3FHQ5GhHek5OMWyc3+6h/CIg9qXejYU=";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-m+eJqHJ9tTHP6dqHyjDxe/fexoEX736Qs8KcrnCqku8=";
  };

  # openssl should not be provided by vendors, not even on windows
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = lib.optional nativeTls openssl;

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/${finalAttrs.pname}"
        else
          lib.getExe buildPackages.${finalAttrs.pname};
    in
    ''
      mkdir -p $out/share/{completions,man,schemas}
      ${exe} completion -d "$out"/share/completions bash elvish fish powershell zsh
      ${exe} manual "$out"/share/man
      ${exe} json-schema "$out"/share/schemas
    ''
    + lib.optionalString installManPages ''
      installManPage "$out"/share/man/*
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion --cmd ${finalAttrs.pname} \
        --bash "$out"/share/completions/${finalAttrs.pname}.bash \
        --fish "$out"/share/completions/${finalAttrs.pname}.fish \
        --zsh "$out"/share/completions/_${finalAttrs.pname}
    '';

  meta = {
    description = "CLI to manage emails";
    mainProgram = finalAttrs.pname;
    homepage = "https://github.com/pimalaya/${finalAttrs.pname}";
    changelog = "https://github.com/pimalaya/${finalAttrs.pname}/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      soywod
      yanganto
    ];
  };
})
