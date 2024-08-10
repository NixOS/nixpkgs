{ lib
, rustPlatform
, fetchFromSourcehut
, stdenv
, pkg-config
, darwin
, installShellFiles
, installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform
, installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform
, notmuch
, buildNoDefaultFeatures ? false
, buildFeatures ? []
}:

rustPlatform.buildRustPackage rec {
  # Learn more about available cargo features at:
  #  - <https://pimalaya.org/neverest/cli/latest/installation.html#cargo>
  #  - <https://git.sr.ht/~soywod/neverest-cli/tree/master/item/Cargo.toml#L18>
  inherit buildNoDefaultFeatures buildFeatures;

  pname = "neverest";
  version = "1.0.0-beta";

  src = fetchFromSourcehut {
    owner = "~soywod";
    repo = "${pname}-cli";
    rev = "v${version}";
    hash = "sha256-3PSJyhxrOCiuHUeVHO77+NecnI5fN5EZfPhYizuYvtE=";
  };

  cargoHash = "sha256-i5or8oBtjGqOfTfwB7dYXn/OPgr5WEWNEvC0WdCCG+c=";

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildInputs = [ ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ AppKit Cocoa Security ])
    ++ lib.optional (builtins.elem "notmuch" buildFeatures) notmuch;

  # TODO: unit tests temporarily broken, remove this line for the next
  # beta.2 release
  doCheck = false;

  postInstall = lib.optionalString installManPages ''
    mkdir -p $out/man
    $out/bin/neverest man $out/man
    installManPage $out/man/*
  '' + lib.optionalString installShellCompletions ''
    installShellCompletion --cmd neverest \
      --bash <($out/bin/neverest completion bash) \
      --fish <($out/bin/neverest completion fish) \
      --zsh <($out/bin/neverest completion zsh)
  '';

  meta = with lib; {
    description = "CLI to synchronize, backup and restore emails";
    mainProgram = "neverest";
    homepage = "https://pimalaya.org/neverest/cli/v${version}/";
    changelog = "https://git.sr.ht/~soywod/neverest-cli/tree/v${version}/item/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ soywod ];
  };
}
