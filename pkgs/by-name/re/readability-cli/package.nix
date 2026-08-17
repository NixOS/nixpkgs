{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitLab,
  installShellFiles,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "readability-cli";
  version = "2.4.5-unstable-2026-01-07";

  src = fetchFromGitLab {
    owner = "gardenappl";
    repo = "readability-cli";
    rev = "72c232e3cd33e91ab04b7dacfa649082b8037436";
    hash = "sha256-5a4mQbfJKAL8nOSnqnKQCjb6bJEEX59puwCw0KmddOo=";
  };

  postPatch = ''
    # Set a script name to avoid yargs using index.js as $0
    substituteInPlace common.mjs \
      --replace-fail '.version(false)' '.version(false).scriptName("readable")'
  '';

  npmDepsHash = "sha256-vzNUbC5q5mdmyQZYUsw9Qw/Uxk+H7meW2R8j9R5auPY=";

  nativeBuildInputs = [ installShellFiles ];

  dontNpmBuild = true;

  postInstall = ''
    installManPage readability-cli.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd readable \
      --bash <(SHELL=bash $out/bin/readable --completion) \
      --zsh <(SHELL=zsh $out/bin/readable --completion)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Firefox Reader Mode in your terminal - get useful text from a web page using Mozilla's Readability library";
    homepage = "https://gitlab.com/gardenappl/readability-cli";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ juliusfreudenberger ];
    mainProgram = "readable";
  };
})
