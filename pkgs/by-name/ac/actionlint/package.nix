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

buildGoModule (finalAttrs: {
  pname = "actionlint";
  version = "1.7.12";

  subPackages = [ "cmd/actionlint" ];

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "actionlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mACSb3sYQtkijzk10mPi2ndy3zakonW1jlU7D/DV+SM=";
  };

  vendorHash = "sha256-bPhjeC6xcemV4KZx+Kc/Wbdz6Be6WsiolFTrJ7TURA0=";

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
    "-X github.com/rhysd/actionlint.version=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://rhysd.github.io/actionlint/";
    description = "Static checker for GitHub Actions workflow files";
    changelog = "https://github.com/rhysd/actionlint/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
    mainProgram = "actionlint";
  };
})
