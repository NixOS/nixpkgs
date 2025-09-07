{
  curl,
  expat,
  fetchFromGitHub,
  fuse3,
  gumbo,
  help2man,
  lib,
  libuuid,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "httpdirfs";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "fangfufu";
    repo = "httpdirfs";
    tag = finalAttrs.version;
    hash = "sha256-6TGptKWX0hSNL3Z3ioP7puzozWLiMhCybN7hATQdD/k=";
  };

  nativeBuildInputs = [
    help2man
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    expat
    fuse3
    gumbo
    libuuid
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=attribute-warning"
    "-Wno-error=pedantic"
  ];

  passthru = {
    tests.version = testers.testVersion {
      command = "${lib.getExe finalAttrs.finalPackage} --version";
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/fangfufu/httpdirfs/releases/tag/${finalAttrs.version}";
    description = "FUSE filesystem for HTTP directory listings";
    homepage = "https://github.com/fangfufu/httpdirfs";
    license = lib.licenses.gpl3Only;
    mainProgram = "httpdirfs";
    maintainers = with lib.maintainers; [
      sbruder
      schnusch
      anthonyroussel
    ];
    platforms = lib.platforms.linux;
  };
})
