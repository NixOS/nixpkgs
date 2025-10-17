{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkgsBuildBuild,
  stdenv,
  zlib,
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

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    zlib
  ];

  # Needing libgit2 <=1.8.0
  #env.LIBGIT2_NO_VENDOR = 1;

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  cargoBuildFlags = [ "--locked" ];
  RUSTFLAGS = [
    "-C debuginfo=0"
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
