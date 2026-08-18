{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  oniguruma,
  zlib,
  gitMinimal,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-dive";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "gitext-rs";
    repo = "git-dive";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sy2qNFn8JLE173HVWfFXBx21jcx4kpFMwi9a0m38lso=";
  };

  cargoHash = "sha256-qRF111ofiM8SNUjQfpDg75OPpJnP7fOqM8Ih3NQUdGY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    oniguruma
    zlib
  ];

  nativeCheckInputs = [
    gitMinimal
  ];

  # don't use vendored libgit2
  buildNoDefaultFeatures = true;

  checkFlags = [
    # requires internet access
    "--skip=screenshot"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.name nixbld
    git config --global user.email nixbld@example.com
  '';

  env = {
    LIBGIT2_NO_VENDOR = 1;
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = {
    description = "Dive into a file's history to find root cause";
    homepage = "https://github.com/gitext-rs/git-dive";
    changelog = "https://github.com/gitext-rs/git-dive/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "git-dive";
  };
})
