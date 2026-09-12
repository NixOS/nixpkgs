{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "circumflex";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    tag = finalAttrs.version;
    hash = "sha256-JjwtLMMKQ5L99IEqFqq80QsBPt/lfJiE0ck4M+nmgbo=";
  };

  vendorHash = "sha256-0YsQ//6bPP9I0OAHmTHQSSpCqqvE2A+2hPoUz5SEuQI=";

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
