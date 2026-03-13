{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  unixtools,
  pkg-config,
  alsa-lib,
  libxtst,
  libxi,
  libx11,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "daktilo";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "daktilo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gIBWonJGX6IpxyBeMulcfQEExsG1GrBVQLZbBBA1ruc=";
  };

  cargoHash = "sha256-MV2XvBtVQyxu2PVCgE+5C9EBec11JwYgyeoyg29C7Ig=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libx11
    libxi
    libxtst
  ];

  nativeCheckInputs = [
    unixtools.script
  ];

  postInstall = ''
    mkdir -p man completions

    OUT_DIR=man $out/bin/daktilo-mangen
    OUT_DIR=completions $out/bin/daktilo-completions

    installManPage man/daktilo.1
    installShellCompletion \
      completions/daktilo.{bash,fish} \
      --zsh completions/_daktilo

    rm $out/bin/daktilo-{completions,mangen}
  '';

  meta = {
    description = "Turn your keyboard into a typewriter";
    homepage = "https://github.com/orhun/daktilo";
    changelog = "https://github.com/orhun/daktilo/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ orhun ];
    mainProgram = "daktilo";
  };
})
