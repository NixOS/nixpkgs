{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  oniguruma,
  zlib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-igitt";
  version = "0.1.19";

  src = fetchFromGitHub {
    owner = "mlange-42";
    repo = "git-igitt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kryC07G/sMMtz1v6EZPYdCunl/CjC4H+jAV3Y91X9Cg=";
  };

  cargoHash = "sha256-45ME5Uaqa6qKuqvO1ETEVrySiAylPmx30uShQPPGNmY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    oniguruma
    zlib
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive, cross-platform Git terminal application with clear git graphs arranged for your branching model";
    homepage = "https://github.com/mlange-42/git-igitt";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.pinage404 ];
    mainProgram = "git-igitt";
  };
})
