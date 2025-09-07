{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  bzip2,
  bzip3,
  xz,
  git,
  zlib,
  zstd,

  # RAR code is under non-free unRAR license
  # see the meta.license section below for more details
  enableUnfree ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "ouch";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "ouch-org";
    repo = "ouch";
    rev = version;
    hash = "sha256-vNeOJOyQsjDUzScA1a/W+SI1Z67HTLiHjwWZZpr1Paw=";
  };

  cargoHash = "sha256-mMoYJ3dLpb1Y3Ocdyxg1brE7xYeZBbtUg0J/2HTK0hE=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    rustPlatform.bindgenHook
  ];

  nativeCheckInputs = [
    git
  ];

  buildInputs = [
    bzip2
    bzip3
    xz
    zlib
    zstd
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "use_zlib"
    "use_zstd_thin"
    # "bzip3" will be optional in the next version
    "zstd/pkg-config"
  ]
  ++ lib.optionals enableUnfree [
    "unrar"
  ];

  postInstall = ''
    installManPage artifacts/*.1
    installShellCompletion artifacts/ouch.{bash,fish} --zsh artifacts/_ouch
  '';

  env.OUCH_ARTIFACTS_FOLDER = "artifacts";

  meta = {
    description = "Command-line utility for easily compressing and decompressing files and directories";
    homepage = "https://github.com/ouch-org/ouch";
    changelog = "https://github.com/ouch-org/ouch/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ] ++ lib.optionals enableUnfree [ unfreeRedistributable ];
    maintainers = with lib.maintainers; [
      figsoda
      psibi
      krovuxdev
    ];
    mainProgram = "ouch";
  };
}
