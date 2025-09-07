{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_20,
  installShellFiles,
  makeWrapper,
  stdenv,
}:

buildNpmPackage rec {
  pname = "clever-tools";

  version = "3.14.1";

  nodejs = nodejs_20;

  src = fetchFromGitHub {
    owner = "CleverCloud";
    repo = "clever-tools";
    rev = version;
    hash = "sha256-3nCfo54p7O4Oik3fTf842IahEQnu26oPS5aOgHdhJKg=";
  };

  npmDepsHash = "sha256-NWi+LJWLT2z3980d3rxBkNYzmMS6JwuP49ltGtKRd5c=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib/clever-tools
    cp build/clever.cjs $out/lib/clever-tools/clever.cjs

    makeWrapper ${nodejs}/bin/node $out/bin/clever \
      --add-flags "$out/lib/clever-tools/clever.cjs" \
      --set NO_UPDATE_NOTIFIER true

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd clever \
      --bash <($out/bin/clever --bash-autocomplete-script $out/bin/clever) \
      --zsh <($out/bin/clever --zsh-autocomplete-script $out/bin/clever)
  '';

  meta = {
    homepage = "https://github.com/CleverCloud/clever-tools";
    changelog = "https://github.com/CleverCloud/clever-tools/blob/${version}/CHANGELOG.md";
    description = "Deploy on Clever Cloud and control your applications, add-ons, services from command line";
    license = lib.licenses.asl20;
    mainProgram = "clever";
    teams = [ lib.teams.clevercloud ];
  };
}
