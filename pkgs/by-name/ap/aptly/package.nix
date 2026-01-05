{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  gnupg,
  bzip2,
  xz,
  graphviz,
  testers,
  aptly,
}:

buildGoModule (finalAttrs: {
  pname = "aptly";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "aptly-dev";
    repo = "aptly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jkljg05C4GJ4F9l6mKAU4JCH8I0/bjzfb74X714z4UI=";
  };

  vendorHash = "sha256-3pFVAVvIpJut2YYxvnCQbBpdwwmUbZIyrx0WoQrU+nQ=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  preBuild = ''
    echo ${finalAttrs.version} > VERSION
  '';

  postInstall = ''
    installShellCompletion --bash --name aptly completion.d/aptly
    installShellCompletion --zsh --name _aptly completion.d/_aptly
    wrapProgram $out/bin/aptly \
      --prefix PATH : ${
        lib.makeBinPath [
          gnupg
          bzip2
          xz
          graphviz
        ]
      }
  '';

  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = aptly;
    command = "aptly version";
  };

  meta = {
    homepage = "https://www.aptly.info";
    description = "Debian repository management tool";
    license = lib.licenses.mit;
    changelog = "https://github.com/aptly-dev/aptly/releases/tag/v${finalAttrs.version}";
    maintainers = [ lib.maintainers.montag451 ];
    teams = [ lib.teams.bitnomial ];
    mainProgram = "aptly";
  };
})
