{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  cmake,
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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ouch";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ouch-org";
    repo = "ouch";
    rev = finalAttrs.version;
    hash = "sha256-yQt+FeEUgC6JurFwOU1Yd++OYT75TmGO7/qchng/BUA=";
  };

  cargoHash = "sha256-3/uO5WLcGXWryJSQ8UhJGecpAD2vQVE2c19vYAHtT/4=";

  nativeBuildInputs = [
    cmake
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
    "bzip3"
    "zstd/pkg-config"
  ]
  ++ lib.optionals enableUnfree [
    "unrar"
  ];

  postInstall = ''
    installManPage artifacts/*.1
    installShellCompletion artifacts/ouch.{bash,fish} --zsh artifacts/_ouch --nushell artifacts/ouch.nu
  '';

  env.OUCH_ARTIFACTS_FOLDER = "artifacts";

  meta = {
    description = "Command-line utility for easily compressing and decompressing files and directories";
    homepage = "https://github.com/ouch-org/ouch";
    changelog = "https://github.com/ouch-org/ouch/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ] ++ lib.optionals enableUnfree [ unfreeRedistributable ];
    maintainers = with lib.maintainers; [
      psibi
      krovuxdev
      philocalyst
    ];
    platforms = lib.platforms.all;
    mainProgram = "ouch";
  };
})
