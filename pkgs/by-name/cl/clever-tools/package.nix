{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  installShellFiles,
  makeWrapper,
  stdenv,
}:

buildNpmPackage rec {
  pname = "clever-tools";

  version = "5.0.2";

  nodejs = nodejs_24;

  src = fetchFromGitHub {
    owner = "CleverCloud";
    repo = "clever-tools";
    rev = version;
    hash = "sha256-wXVgNOOOo5OJBigKF+Kl1EpNMV5wuCI8nOfJDivv6is=";
  };

  npmDepsHash = "sha256-/zgGrKHRfAmJl4+z4MZ4hbkLTXo7i3BQX8ph4ZtDuRM=";

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
    maintainers = [ lib.maintainers.floriansanderscc ];
  };
}
