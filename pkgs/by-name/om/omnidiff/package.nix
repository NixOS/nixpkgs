{
  fetchFromGitHub,
  git,
  installShellFiles,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "omnidiff";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ivankovic";
    repo = "omnidiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UKVsTsWot1EJWU0k2atnomcPDlUEbJl2xk03K+SfNeI=";
  };

  cargoHash = "sha256-XUZPUVamZ/edJueCELqW2+j0Mh4fXUST/VIN2y/17mo=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  cargoBuildFlags = [
    "--bin"
    "omnidiff"
  ];

  cargoTestFlags = [
    "--lib"
    "omnidiff"
  ];

  useNextest = true;

  postInstall = ''
    $out/bin/omnidiff util man > omnidiff.1
    installManPage omnidiff.1
    installShellCompletion --cmd omnidiff \
      --bash <($out/bin/omnidiff util completions bash) \
      --zsh <($out/bin/omnidiff util completions zsh) \
      --fish <($out/bin/omnidiff util completions fish)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Content-aware diff tool";
    homepage = "https://ivankovic.github.io/omnidiff/";
    changelog = "https://github.com/ivankovic/omnidiff/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ gs-101 ];
    mainProgram = "omnidiff";
    platforms = lib.platforms.linux ++ lib.platforms.windows;
  };
})
