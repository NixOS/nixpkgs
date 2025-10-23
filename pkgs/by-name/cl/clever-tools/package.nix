{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  installShellFiles,
  makeWrapper,
  stdenv,
}:

buildNpmPackage rec {
  pname = "clever-tools";

  version = "4.2.0";

  nodejs = nodejs_22;

  src = fetchFromGitHub {
    owner = "CleverCloud";
    repo = "clever-tools";
    rev = version;
    hash = "sha256-1llFIq5F4FTxJuIdFov8+XExAZmfIMy81fP7OT2JbbE=";
  };

  npmDepsHash = "sha256-UzjGYHIG2fza4HJqiha0dyIqKY9v0O9YvbmcMUcMhAY=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    node scripts/bundle-cjs.js ${version} false
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/clever-tools
    cp build/${version}/clever.cjs $out/lib/clever-tools/clever.cjs

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
