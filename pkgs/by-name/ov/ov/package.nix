{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pandoc,
  makeWrapper,
  testers,
  ov,
}:

buildGoModule (finalAttrs: {
  pname = "ov";
  version = "0.50.2";

  src = fetchFromGitHub {
    owner = "noborus";
    repo = "ov";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tmGOyafVocbeEfHQcvysBuX/LJO62xRuclQ6Xy+Q1Gs=";
  };

  vendorHash = "sha256-Y+rNTJoSbTccHVPA/TTQGkkYpYr72WB8gqwzWfqPRH0=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=v${finalAttrs.version}"
    "-X=main.Revision=${finalAttrs.src.rev}"
  ];

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
    pandoc
    makeWrapper
  ];

  outputs = [
    "out"
    "doc"
  ];

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd ov \
        --bash <($out/bin/ov --completion bash) \
        --fish <($out/bin/ov --completion fish) \
        --zsh <($out/bin/ov --completion zsh)
    ''
    + ''
      mkdir -p $out/share/$name
      cp $src/ov-less.yaml $out/share/$name/less-config.yaml
      makeWrapper $out/bin/ov $out/bin/ov-less --add-flags "--config $out/share/$name/less-config.yaml"

      mkdir -p $doc/share/doc/$name
      pandoc -s < $src/README.md > $doc/share/doc/$name/README.html
      mkdir -p $doc/share/$name
      cp $src/ov.yaml $doc/share/$name/sample-config.yaml
    '';

  passthru.tests = {
    version = testers.testVersion {
      package = ov;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "Feature-rich terminal-based text viewer";
    homepage = "https://noborus.github.io/ov";
    changelog = "https://github.com/noborus/ov/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      farcaller
    ];
    mainProgram = "ov";
  };
})
