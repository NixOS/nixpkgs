{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  sqlite,
  writableTmpDirAsHomeHook,
  cacert,
  podman,
  docker-compose,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "snouty";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "antithesishq";
    repo = "snouty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wm0AtZr63kiuyQ7QfNFaGiSx48jbn2XkbDeE7VyvcOY=";
  };

  cargoHash = "sha256-hYnPz3aMS9iEWepJ3LEW0fr274LRgsWw2cnqCjsjDrQ=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    sqlite
  ];

  # Docker and Podman run the credential helper as docker-credential-snouty,
  # and snouty acts as the helper when it is started by that name.
  postInstall = ''
    ln -s snouty $out/bin/docker-credential-snouty
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd snouty \
      --bash <($out/bin/snouty completions bash) \
      --fish <($out/bin/snouty completions fish) \
      --zsh <($out/bin/snouty completions zsh)
  '';

  useNextest = true;

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    cacert
    podman
    docker-compose
    gitMinimal
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for the Antithesis API";
    homepage = "https://github.com/antithesishq/snouty";
    changelog = "https://github.com/antithesishq/snouty/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      carlsverre
      winter
    ];
    mainProgram = "snouty";
  };
})
