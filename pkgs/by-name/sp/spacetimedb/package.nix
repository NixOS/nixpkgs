{
  lib,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  perl,
<<<<<<< HEAD
  openssl,
=======
  git,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  versionCheckHook,
  librusty_v8 ? callPackage ./librusty_v8.nix {
    inherit (callPackage ./fetchers.nix { }) fetchLibrustyV8;
  },
<<<<<<< HEAD
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spacetimedb";
  version = "1.10.0";
=======
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spacetimedb";
  version = "1.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "clockworklabs";
    repo = "spacetimedb";
<<<<<<< HEAD
    rev = "1d576dc75ca066879f6d9ee4d156c5bce940bd31";
    hash = "sha256-rqR4A7JpIgdTxjIvq4KNmvU3LMLUZS1AaLSQWVk+tdw=";
  };

  cargoHash = "sha256-FHzFxDnpQL0XSyTAfANsK60y8aOFQMkF4KZFdaspYEI=";
=======
    tag = "v${finalAttrs.version}";
    hash = "sha256-fUs3EdyOzUogEEhSOnpFrA1LeivEa/crmlhQcf2lGUE=";
  };

  cargoHash = "sha256-EWLfAyYN/U2kt03lmR8mVXc+j/DbjFat+RysNUt99QI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
    perl
<<<<<<< HEAD
  ];

  buildInputs = [
    openssl
=======
    git
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  cargoBuildFlags = [ "-p spacetimedb-standalone -p spacetimedb-cli" ];

<<<<<<< HEAD
  preCheck = ''
    # server tests require home dir
    export HOME=$(mktemp -d)
  '';

  checkFlags = [
    # require wasm32-unknown-unknown target
    "--skip=codegen"
    "--skip=publish"
=======
  checkFlags = [
    # requires wasm32-unknown-unknown target
    "--skip=codegen"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  doInstallCheck = true;

<<<<<<< HEAD
  env = {
    RUSTY_V8_ARCHIVE = librusty_v8;
    # used by crates/cli/build.rs to set GIT_HASH at compile time
    SPACETIMEDB_NIX_BUILD_GIT_COMMIT = finalAttrs.src.rev;
    # required to make jemalloc_tikv_sys build
    CFLAGS = "-O";
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/spacetime";
=======
  env.RUSTY_V8_ARCHIVE = librusty_v8;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/spacetime";
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postInstall = ''
    mv $out/bin/spacetimedb-cli $out/bin/spacetime
  '';

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Full-featured relational database system that lets you run your application logic inside the database";
    homepage = "https://github.com/clockworklabs/SpacetimeDB";
    license = lib.licenses.bsl11;
    mainProgram = "spacetime";
    maintainers = with lib.maintainers; [ akotro ];
  };
})
