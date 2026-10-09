{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  libgit2,
  libz,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-cliff";
  version = "2.14.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fhhlHjVXernPKNXmeIjRGocyHDPCwo+//yTjb5pVGbo=";
  };

  cargoHash = "sha256-yO8Ov2+cJky3JqePy2mnOd4AFEKJRuAirm/iozTwArU=";

  env = {
    LIBGIT2_NO_VENDOR = 1;
    LIBZ_SYS_STATIC = 0;
    ZSTD_SYS_USE_PKG_CONFIG = 1;
  };

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    libgit2
    libz
    zstd
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export OUT_DIR=$(mktemp -d)

    # Generate shell completions
    $out/bin/git-cliff-completions
    installShellCompletion \
      --bash $OUT_DIR/git-cliff.bash \
      --fish $OUT_DIR/git-cliff.fish \
      --zsh $OUT_DIR/_git-cliff

    # Generate man page
    $out/bin/git-cliff-mangen
    installManPage $OUT_DIR/git-cliff.1
  '';

  meta = {
    description = "Highly customizable Changelog Generator that follows Conventional Commit specifications";
    homepage = "https://github.com/orhun/git-cliff";
    changelog = "https://github.com/orhun/git-cliff/blob/v${finalAttrs.version}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    maintainers = with lib.maintainers; [
      siraben
      matthiasbeyer
    ];
    mainProgram = "git-cliff";
  };
})
