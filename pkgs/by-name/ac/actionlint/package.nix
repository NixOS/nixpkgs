{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  python3Packages,
  ronn,
  shellcheck,
}:

buildGoModule rec {
  pname = "actionlint";
  version = "1.7.9";

  subPackages = [ "cmd/actionlint" ];

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "actionlint";
    tag = "v${version}";
    hash = "sha256-QZVZ4pF69rtdXmFIMXooTpAjzPM4TTzUKVVMWYqmUvQ=";
  };

  vendorHash = "sha256-oejeEImMgNXnbDIFg7MslcisVJj4Pl150ZMJ0YqGdLM=";

  nativeBuildInputs = [
    makeWrapper
    ronn
    installShellFiles
  ];

  postInstall = ''
    ronn --roff man/actionlint.1.ronn
    installManPage man/actionlint.1
    wrapProgram "$out/bin/actionlint" \
      --prefix PATH : ${
        lib.makeBinPath [
          python3Packages.pyflakes
          shellcheck
        ]
      }
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/rhysd/actionlint.version=${version}"
  ];

  meta = {
    homepage = "https://rhysd.github.io/actionlint/";
    description = "Static checker for GitHub Actions workflow files";
    changelog = "https://github.com/rhysd/actionlint/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
    mainProgram = "actionlint";
  };
}
