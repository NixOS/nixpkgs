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
  version = "2.2.1";
  cargoHash = "sha256-KDsvF8wHMIEw+rjBJpUTgX6QIhcCMVjLWcPWklpxG3Q=";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = "himalaya";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fYspChAGb0PLdsgP5GViAwp4NdmDXDyait0mpqIkGfQ=";
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
          "$out/bin/himalaya"
        else
          lib.getExe buildPackages.himalaya;
    in
    ''
      mkdir -p $out/share/{completions,man,schemas}
      ${exe} completion -d "$out"/share/completions bash elvish fish powershell zsh
      ${exe} manual -d "$out"/share/man
      ${exe} json-schema -d "$out"/share/schemas
    ''
    + lib.optionalString installManPages ''
      installManPage "$out"/share/man/*
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion --cmd himalaya \
        --bash "$out"/share/completions/himalaya.bash \
        --fish "$out"/share/completions/himalaya.fish \
        --zsh "$out"/share/completions/_himalaya
    '';

  meta = {
    description = "CLI to manage emails";
    mainProgram = "himalaya";
    homepage = "https://github.com/pimalaya/himalaya";
    changelog = "https://github.com/pimalaya/himalaya/releases/tag/${finalAttrs.src.tag}";
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
