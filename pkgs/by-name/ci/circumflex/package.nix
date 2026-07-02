{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "circumflex";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    tag = finalAttrs.version;
    hash = "sha256-MA/7BMXuKydvtfeY+kMQiAUcCuEvwbXopaViM3wPvUE=";
  };

  vendorHash = "sha256-wib8VrgkKtMkRx7RtQMJPtGPtTh6eGoI+8gp60z7l+w=";

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
