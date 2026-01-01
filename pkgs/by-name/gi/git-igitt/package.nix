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

<<<<<<< HEAD
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-igitt";
  version = "0.1.19";
=======
let
  pname = "git-igitt";
  version = "0.1.18";
in
rustPlatform.buildRustPackage {
  inherit pname version;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mlange-42";
    repo = "git-igitt";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-kryC07G/sMMtz1v6EZPYdCunl/CjC4H+jAV3Y91X9Cg=";
  };

  cargoHash = "sha256-45ME5Uaqa6qKuqvO1ETEVrySiAylPmx30uShQPPGNmY=";
=======
    rev = version;
    hash = "sha256-JXEWnekL9Mtw0S3rI5aeO1HB9kJ7bRJDJ6EJ4ATlFeQ=";
  };

  cargoHash = "sha256-ndxxkYMFHAX6uourCyUpvJYcZCXQ5X2CMX4jTJmNRiQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
