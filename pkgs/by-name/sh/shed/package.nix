{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shed";
  version = "0.42.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "km-clay";
    repo = "shed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-keZE86qlwexHnw8eKv82E/3spWOJ8ya2zOC+VSidQek=";
  };

  cargoHash = "sha256-pfiN++c+O+do5DDTV5aH74doNJQ9pn77KJWURCYpgVA=";

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
