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
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "noborus";
    repo = "ov";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YpWDIA1cPz3rA0FrbagLcCgP4InYmTgHbCrwuCETNoA=";
  };

  vendorHash = "sha256-Wi9mJJ63XXpfZBUa1g4RIp++3AVZlTpeKkgUz4TrJR4=";

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
    maintainers = [ ];
    mainProgram = "ov";
  };
})
