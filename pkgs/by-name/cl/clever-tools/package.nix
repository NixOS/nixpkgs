{ lib
, buildNpmPackage
, fetchFromGitHub
, nodejs_18
, installShellFiles
}:

buildNpmPackage rec {
  pname = "clever-tools";

  version = "3.8.0";

  nodejs = nodejs_18;

  src = fetchFromGitHub {
    owner = "CleverCloud";
    repo = "clever-tools";
    rev = version;
    hash = "sha256-Y9lcnOaii58KU99VwBbgywNwQQKhlye2SmLhU6n48AM=";
  };

  npmDepsHash = "sha256-yzwrsW/X6q9JUXI6Gma7/5nk5Eu6cBOdXcHu49vi6w0=";

  dontNpmBuild = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd clever \
      --bash <($out/bin/clever --bash-autocomplete-script) \
      --zsh <($out/bin/clever --zsh-autocomplete-script)
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
