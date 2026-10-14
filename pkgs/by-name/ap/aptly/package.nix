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
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "aptly-dev";
    repo = "aptly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fjNN8EffY9G8YX/uME5ehs2zZj/YRA62y/muqigWSnE=";
  };

  vendorHash = "sha256-QPYKdiEiV1iS3xJ3A66ILUXAlj0TGXuGf11wzdX3Z7Y=";

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
  excludedPackages = [
    "system"
  ];

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
    maintainers = with lib.maintainers; [
      cdepillabout
      montag451
      wraithm
    ];
    mainProgram = "aptly";
  };
})
