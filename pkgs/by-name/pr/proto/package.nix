{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  makeBinaryWrapper,
  pkg-config,
<<<<<<< HEAD
  perl,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

rustPlatform.buildRustPackage rec {
  pname = "proto";
<<<<<<< HEAD
  version = "0.53.0";
=======
  version = "0.50.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = "proto";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-gRu/e4CMMKbmUDBbRbrHMpYZ+N1tGUKt758SP3Sp1uI=";
  };

  cargoHash = "sha256-pwJNNwCjyEJRh4PPq/BqK3DbeJkzElkwmpaQkd/hKMQ=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv

=======
    hash = "sha256-X448S7eGx60CgpZkV81bVuxAc6HuIRNeHJgKW4min/E=";
  };

  cargoHash = "sha256-PUNBq4VWufCeFdhI7zThEyDMA4UHpL95uVdv4uouxBQ=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];
  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
<<<<<<< HEAD
    perl
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  # Tests requires network access
  doCheck = false;
  cargoBuildFlags = [
    "--bin proto"
    "--bin proto-shim"
  ];

  postInstall = ''
    # proto looks up a proto-shim executable file in $PROTO_LOOKUP_DIR
    wrapProgram $out/bin/proto \
      --set PROTO_LOOKUP_DIR $out/bin
  '';

  meta = {
    description = "Pluggable multi-language version manager";
    longDescription = ''
      proto is a pluggable next-generation version manager for multiple programming languages. A unified toolchain.
    '';
    homepage = "https://moonrepo.dev/proto";
    changelog = "https://github.com/moonrepo/proto/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nokazn ];
    mainProgram = "proto";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
