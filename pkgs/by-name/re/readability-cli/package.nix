{
  lib,
  buildNpmPackage,
  fetchFromGitLab,
  installShellFiles,
}:

buildNpmPackage rec {
  pname = "readability-cli";
  version = "2.4.4";

  src = fetchFromGitLab {
    owner = "gardenappl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pvAp3ZJ8/FPhrSMC8B4U1m5zuBNRP/HcsXkrW6QYgSQ=";
  };

  postPatch = ''
    # Set a script name to avoid yargs using index.js as $0
    substituteInPlace common.mjs \
      --replace '.version(false)' '.version(false).scriptName("readable")'
  '';

  npmDepsHash = "sha256-X1pcgDm8C4G+hIsgx3sAVFQPadWsULvXrdLAIHnpjmE=";

  nativeBuildInputs = [ installShellFiles ];

  dontNpmBuild = true;

  postInstall = ''
    installManPage readability-cli.1
    installShellCompletion --cmd readable \
      --bash <(SHELL=bash $out/bin/readable --completion) \
      --zsh <(SHELL=zsh $out/bin/readable --completion)
  '';

  meta = with lib; {
    description = "Firefox Reader Mode in your terminal - get useful text from a web page using Mozilla's Readability library";
    homepage = "https://gitlab.com/gardenappl/readability-cli";
    license = licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "readable";
  };
}
