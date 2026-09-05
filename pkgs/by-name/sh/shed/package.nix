{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shed";
  version = "0.40.14";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "km-clay";
    repo = "shed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7cM3X+cufu68+3qiMV2DLCpDCvOrVkvo8pSmk9rfYMQ=";
  };

  cargoHash = "sha256-ViKblsM4q65wjCXNbPPpJUbUKAI4x13JMwNzm2XRujE=";

  # the test suite has to run single-threaded
  # or else global state will get clobbered by concurrent threads
  checkFlags = [ "--test-threads=1" ];

  # install help pages
  env.SHED_HELP_DIR = "${placeholder "out"}/share/shed/help";
  postInstall = ''
    install -Dm644 include/help/* -t $out/share/shed/help
  '';

  passthru.shellPath = "/bin/shed";

  meta = {
    description = "POSIX-compatible shell and modal text editor";
    homepage = "https://github.com/km-clay/shed";
    changelog = "https://github.com/km-clay/shed/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pagedMov ];
    mainProgram = "shed";
    platforms = lib.platforms.linux;
  };
})
