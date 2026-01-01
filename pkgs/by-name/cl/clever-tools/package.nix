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

<<<<<<< HEAD
  version = "4.4.1";
=======
  version = "4.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nodejs = nodejs_22;

  src = fetchFromGitHub {
    owner = "CleverCloud";
    repo = "clever-tools";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-ssbm2XevvB1zzVVeOUTxUUKcD8smlsOjy9efnFLw03M=";
  };

  npmDepsHash = "sha256-VxFxMvbkEnjooSq1Ats4tC8Dcqr3EVffccxOXNha4MY=";
=======
    hash = "sha256-5LRzYhBcf+C5DgUmeCPu/k52MGuuNjWgXrnP5kl0Z2g=";
  };

  npmDepsHash = "sha256-PRo5XKBIJiYaiC/7L6ycP7HCJQq/J0HBPYhuzBTO2ZY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
