{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "circumflex";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    tag = finalAttrs.version;
    hash = "sha256-MOqm0z3ase/T9NzZ7whVOBAeUnlnDdEIqqXfE/EtgVw=";
  };

  vendorHash = "sha256-88JA+WWAl6XXjP222rDvEGWGB2VSMs90+28EsCW9WPE=";

  nativeBuildInputs = [
    installShellFiles
  ];

  excludedPackages = [
    "gen-completions"
  ];

  postInstall = ''
    installManPage share/man/clx.1

    installShellCompletion --bash share/completions/clx.bash
    installShellCompletion --fish share/completions/clx.fish
    installShellCompletion --zsh share/completions/_clx
  '';

  meta = {
    description = "Command line tool for browsing Hacker News in your terminal";
    homepage = "https://github.com/bensadeh/circumflex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mktip ];
    mainProgram = "clx";
  };
})
