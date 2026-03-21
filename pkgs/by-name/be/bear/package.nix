{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  lld,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bear";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "rizsotto";
    repo = "bear";
    rev = finalAttrs.version;
    hash = "sha256-/sR0kIAqXaQkksoUvgSt2q1ZMQObeiLCr3TGalYiHs0=";
  };

  cargoHash = "sha256-rjtf+8ZnkpTX6by20QN2VydWuuLRMvkDB8OTPlDCagI=";

  nativeBuildInputs = [
    installShellFiles
    lld
  ];

  postPatch = ''
    substituteInPlace bear/build.rs \
      --replace-fail 'const DEFAULT_WRAPPER_PATH: &str = "/usr/local/libexec/bear";' \
        "const DEFAULT_WRAPPER_PATH: &str = \"$out/libexec/bear\";" \
      --replace-fail 'const DEFAULT_PRELOAD_PATH: &str = "/usr/local/libexec/bear/$LIB";' \
        "const DEFAULT_PRELOAD_PATH: &str = \"$out/lib\";"
  '';

  postInstall = ''
    # wrapper should not end up on path
    install -d $out/libexec/bear
    mv $out/bin/wrapper $out/libexec/bear/wrapper

    installManPage man/bear.1
  '';

  # Functional tests use loopback networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Tool that generates a compilation database for clang tooling";
    mainProgram = "bear";
    longDescription = ''
      Note: the bear command is very useful to generate compilation commands
      e.g. for YouCompleteMe.  You just enter your development nix-shell
      and run `bear make`.  It's not perfect, but it gets a long way.
    '';
    homepage = "https://github.com/rizsotto/Bear";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ DieracDelta ];
  };
})
