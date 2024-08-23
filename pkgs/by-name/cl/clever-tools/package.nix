{ lib
, buildNpmPackage
, fetchFromGitHub
, nodejs_18
, installShellFiles
, stdenv
}:

buildNpmPackage rec {
  pname = "clever-tools";

  version = "3.8.2";

  nodejs = nodejs_18;

  src = fetchFromGitHub {
    owner = "CleverCloud";
    repo = "clever-tools";
    rev = version;
    hash = "sha256-cBFdxJrH/1l6YpvdJTeLQf1zl6pm3IbPryimtewh9fc=";
  };

  npmDepsHash = "sha256-cY7wB0IQPLHOOuOLunjeJASp1Ba7ri8cj05/2HveJ7A=";

  dontNpmBuild = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd clever \
      --bash <($out/bin/clever --bash-autocomplete-script $out/bin/clever) \
      --zsh <($out/bin/clever --zsh-autocomplete-script $out/bin/clever)
  '' + ''
    rm $out/bin/install-clever-completion
    rm $out/bin/uninstall-clever-completion
  '';

  meta = with lib; {
    homepage = "https://github.com/CleverCloud/clever-tools";
    changelog = "https://github.com/CleverCloud/clever-tools/blob/${version}/CHANGELOG.md";
    description = "Deploy on Clever Cloud and control your applications, add-ons, services from command line";
    license = licenses.asl20;
    mainProgram = "clever";
    maintainers = teams.clevercloud.members;
  };
}
