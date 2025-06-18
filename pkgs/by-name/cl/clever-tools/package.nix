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

  version = "3.13.0";

  nodejs = nodejs_20;

  src = fetchFromGitHub {
    owner = "CleverCloud";
    repo = "clever-tools";
    rev = version;
    hash = "sha256-E6MD/fQO7cpczaaTbkZOf/lMOywUUXBP9uUVfTH+Iv8=";
  };

  npmDepsHash = "sha256-Q66Gq8LvZEoRVpwzwbK4D9KLVNk6Rc5SztFGwQUuePI=";

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
