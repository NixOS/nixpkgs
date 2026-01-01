{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkgsBuildBuild,
<<<<<<< HEAD
  oniguruma,
  stdenv,
  zlib,
  pkg-config,
=======
  stdenv,
  zlib,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "amp";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "jmacdonald";
    repo = "amp";
    tag = finalAttrs.version;
    hash = "sha256-YK+HSWTtSVLK8n7NDiif3bBqp/dQW2UTYo3yYcZ5cIA=";
  };

  cargoHash = "sha256-6enFOmIAYOgOdoeA+pk37+BobI5AGPBxjp73Gd4C+gI=";

  nativeBuildInputs = [
    # git rev-parse --short HEAD
    (pkgsBuildBuild.writeShellScriptBin "git" "echo 0000000")
  ];

<<<<<<< HEAD
  buildInputs = [
    oniguruma
  ]
  ++ (lib.optionals stdenv.hostPlatform.isDarwin [
    zlib
  ]);
=======
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    zlib
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Needing libgit2 <=1.8.0
  #env.LIBGIT2_NO_VENDOR = 1;

<<<<<<< HEAD
  # bundled oniguruma failed on gcc15
  env.RUSTONIG_SYSTEM_LIBONIG = 1;

  nativeCheckInputs = [
    pkg-config
=======
  nativeCheckInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Modern text editor inspired by Vim";
    homepage = "https://amp.rs";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      sb0
      aleksana
    ];
    mainProgram = "amp";
  };
})
