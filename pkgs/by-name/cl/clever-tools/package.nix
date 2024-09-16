{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_18,
  installShellFiles,
  stdenv,
}:

buildNpmPackage rec {
  pname = "clever-tools";

  version = "3.8.3";

  nodejs = nodejs_18;

  src = fetchFromGitHub {
    owner = "CleverCloud";
    repo = "clever-tools";
    rev = version;
    hash = "sha256-70wyu8+Jb9kR5lIucBZG9UWIufMhsgMBMkT2ohGvE50=";
  };

  npmDepsHash = "sha256-LljwS6Rd/8WnGpxSHwCr87KWLaRR2i7sMdUuuprYiOE=";

  dontNpmBuild = true;

  nativeBuildInputs = [ installShellFiles ];

  makeWrapperArgs = [ "--set NO_UPDATE_NOTIFIER true" ];

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd clever \
        --bash <($out/bin/clever --bash-autocomplete-script $out/bin/clever) \
        --zsh <($out/bin/clever --zsh-autocomplete-script $out/bin/clever)
    ''
    + ''
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
