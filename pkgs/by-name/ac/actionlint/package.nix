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

let
  version = "1.7.6";
in
buildGoModule {
  pname = "actionlint";
  inherit version;

  subPackages = [ "cmd/actionlint" ];

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "actionlint";
    rev = "v${version}";
    hash = "sha256-NHmz+r7xO84eSQFBNwaI+ctzIgd014rRQtqvi8hOWPE=";
  };

  vendorHash = "sha256-4hBIDrFOADGo3gsTRW8hjBYzmWRo/5yyoM7Ylv3KJBk=";

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
