{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "circumflex";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    tag = finalAttrs.version;
    hash = "sha256-VyUJ7qiaodLTdfGyh3/tLGfNVZCAxImxOuz4ztaaqtg=";
  };

  vendorHash = "sha256-4YL0N8wA8igveYfeL4uZDY5YD1InW0iD3WWq1E/vIJs=";

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
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mktip ];
    mainProgram = "clx";
  };
})
