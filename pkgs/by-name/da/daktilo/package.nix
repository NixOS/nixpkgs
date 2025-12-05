{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  unixtools,
  pkg-config,
  alsa-lib,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "daktilo";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "daktilo";
    rev = "v${version}";
    hash = "sha256-gIBWonJGX6IpxyBeMulcfQEExsG1GrBVQLZbBBA1ruc=";
  };

  cargoHash = "sha256-MV2XvBtVQyxu2PVCgE+5C9EBec11JwYgyeoyg29C7Ig=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    xorg.libX11
    xorg.libXi
    xorg.libXtst
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

  meta = with lib; {
    description = "Turn your keyboard into a typewriter";
    homepage = "https://github.com/orhun/daktilo";
    changelog = "https://github.com/orhun/daktilo/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ orhun ];
    mainProgram = "daktilo";
  };
}
