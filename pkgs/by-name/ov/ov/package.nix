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

buildGoModule rec {
  pname = "ov";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "noborus";
    repo = "ov";
    tag = "v${version}";
    hash = "sha256-xbGo/Hgg5XmJACRa4t4QC2vHse5gJ2D4fmmDKurmfNw=";
  };

  vendorHash = "sha256-YS4HraVJ++ZLvNRVUynsZsA1lVYo91IuMKmRxCBQeKU=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=v${version}"
    "-X=main.Revision=${src.rev}"
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
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Feature-rich terminal-based text viewer";
    homepage = "https://noborus.github.io/ov";
    changelog = "https://github.com/noborus/ov/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      farcaller
      figsoda
    ];
  };
}
