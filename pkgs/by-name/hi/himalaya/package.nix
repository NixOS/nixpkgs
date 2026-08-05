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
  version = "2.0.0";
  hash = "sha256-rOCMjJV0lFSIlvstkSMqGwXKDZsBkWtTYhvXpA73ucA=";
  cargoHash = "sha256-ppZYlGWNS5lXQZNt7RcwJIvU5jp07cXhEpmFJ9UtxRE=";

  withOpenssl = stdenv.hostPlatform.isLinux && builtins.elem "native-tls" buildFeatures;
  emulator = stdenv.hostPlatform.emulator buildPackages;
  exe = stdenv.hostPlatform.extensions.executable;

in
rustPlatform.buildRustPackage {
  inherit
    version
    cargoHash
    buildFeatures
    buildNoDefaultFeatures
    ;

  pname = "himalaya";

  src = fetchFromGitHub {
    inherit hash;
    owner = "pimalaya";
    repo = "himalaya";
    rev = "v${version}";
  };

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = lib.optional withOpenssl openssl;

  postInstall =
    lib.optionalString (lib.hasInfix "wine" emulator) ''
      export WINEPREFIX="''${WINEPREFIX:-$(mktemp -d)}"
      mkdir -p $WINEPREFIX
    ''
    + ''
      mkdir -p $out/share/{applications,completions,man,schemas}
      cp assets/himalaya.desktop "$out"/share/applications/
      ${emulator} "$out"/bin/himalaya${exe} completion -d "$out"/share/completions bash elvish fish powershell zsh
      ${emulator} "$out"/bin/himalaya${exe} manual "$out"/share/man
      ${emulator} "$out"/bin/himalaya${exe} json-schema "$out"/share/schemas
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
    changelog = "https://github.com/pimalaya/himalaya/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      soywod
      yanganto
    ];
  };
}
