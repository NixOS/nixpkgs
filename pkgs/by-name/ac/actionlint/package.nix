{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  pandoc,
  python3Packages,
  shellcheck,
}:

buildGoModule (finalAttrs: {
  pname = "actionlint";
  version = "1.17.0";

  subPackages = [ "cmd/actionlint" ];

  src = fetchFromGitHub {
    owner = "kjanat";
    repo = "actionlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OA6Pzb/DVh3wcF/KFdnAtALBO2YSsch/L28EzZnLxqM=";
  };

  vendorHash = "sha256-PVEf1pJvwQu/2dFS0YhWoXahnTqvqmRdYjVfujjs04k=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
    pandoc
  ];

  postInstall = ''
    pandoc --standalone --from=markdown-smart \
      --to=man --metadata=title:ACTIONLINT --lua-filter=man/inline-code-bold.lua \
      --output=man/actionlint.1 man/actionlint.1.md
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
    "-X actionlint.kjanat.dev.version=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://actionlint.kjanat.dev/";
    description = "Static checker for GitHub Actions workflow files";
    changelog = "https://github.com/kjanat/actionlint/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "actionlint";
  };
})
