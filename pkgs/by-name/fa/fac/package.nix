{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  installShellFiles,
  git,
}:

buildGoModule rec {
  pname = "fac";
  version = "2.0.0-unstable-2023-12-29";

  src = fetchFromGitHub {
    owner = "mkchoi212";
    repo = "fac";
    rev = "d232b05149564701ca3a21cd1a07be2540266cb2";
    hash = "sha256-puSHbrzxTUebK1qRdWh71jY/f7TKgONS45T7PcZcy00=";
  };

  vendorHash = "sha256-bmGRVTjleAFS5GGf2i/zN8k3SBtaEc3RbKSVZyF6eN4=";

  nativeBuildInputs = [
    makeBinaryWrapper
    installShellFiles
  ];

  postInstall = ''
    wrapProgram $out/bin/fac \
      --prefix PATH : ${lib.makeBinPath [ git ]}

    # Install man page, not installed by default
    installManPage assets/doc/fac.1
  '';

  meta = {
    changelog = "https://github.com/mkchoi212/fac/releases/tag/v${version}";
    description = "CUI for fixing git conflicts";
    homepage = "https://github.com/mkchoi212/fac";
    license = lib.licenses.mit;
    mainProgram = "fac";
    maintainers = with lib.maintainers; [ dtzWill ];
  };
}
